import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/budget.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';
import 'package:so_vuon/features/budget/budget_vm.dart';
import 'package:so_vuon/features/budget/upsert_budget_screen.dart';
import 'package:intl/intl.dart';

// Provider to calculate total spending for a given budget period
final budgetSpendingProvider = StreamProvider.family<double, Budget>((ref, budget) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return entryRepository.getEntries().map((entries) {
    final relevantEntries = entries.where((entry) =>
        !entry.date.isBefore(budget.startDate) && !entry.date.isAfter(budget.endDate));
    return relevantEntries.fold<double>(0, (prev, entry) => prev + entry.amount);
  });
});

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetListAsync = ref.watch(budgetListProvider);
    final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

    return Scaffold(
      appBar: AppBar(
        title: const Text('예산 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpsertBudgetScreen()),
              );
            },
          ),
        ],
      ),
      body: budgetListAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return const Center(child: Text('설정된 예산이 없습니다. 예산을 추가해보세요!'));
          }
          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              // Use the new provider to get the current spending
              final spendingAsync = ref.watch(budgetSpendingProvider(budget));

              return spendingAsync.when(
                data: (currentSpending) {
                   final progress = (currentSpending / budget.amount).clamp(0.0, 1.0);
                    return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('${DateFormat.yMMMM('ko_KR').format(budget.startDate)} 예산'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('총 예산: ${currencyFormat.format(budget.amount)}'),
                              Text('사용 금액: ${currencyFormat.format(currentSpending)}'),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress > 0.8 ? Colors.red : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpsertBudgetScreen(budget: budget),
                              ),
                            );
                          },
                        ),
                      );
                },
                loading: () => const Card(margin: EdgeInsets.all(8.0), child: Center(heightFactor: 3, child: CircularProgressIndicator())),
                error: (err, stack) => Card(margin: const EdgeInsets.all(8.0), child: Center(child: Text('지출 로딩 오류: $err'))),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('예산을 불러오는 중 오류가 발생했습니다: $error')),
      ),
    );
  }
}
