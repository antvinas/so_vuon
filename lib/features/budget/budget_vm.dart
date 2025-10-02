import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/budget.dart';
import 'package:so_vuon/data/repos/budget_repository.dart';
import 'package:uuid/uuid.dart';

// Provider to get the list of budgets
final budgetListProvider = StreamProvider<List<Budget>>((ref) {
  final budgetRepository = ref.watch(budgetRepositoryProvider);
  return budgetRepository.getBudgets();
});

// StateNotifier for managing budget creation/editing
class BudgetViewModel extends StateNotifier<AsyncValue<void>> {
  final BudgetRepository _budgetRepository;

  BudgetViewModel(this._budgetRepository) : super(const AsyncValue.data(null));

  Future<void> saveBudget({
    required double amount,
    required Map<String, double> categoryBudgets,
  }) async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final newBudget = Budget(
        id: const Uuid().v4(),
        amount: amount,
        categoryBudgets: categoryBudgets,
        period: 'monthly', // Currently only supports monthly
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
      );
      await _budgetRepository.addBudget(newBudget);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBudget(Budget budget) async {
    state = const AsyncValue.loading();
    try {
      await _budgetRepository.updateBudget(budget);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

    Future<void> deleteBudget(String budgetId) async {
    state = const AsyncValue.loading();
    try {
      await _budgetRepository.deleteBudget(budgetId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final budgetViewModelProvider = StateNotifierProvider<BudgetViewModel, AsyncValue<void>>((ref) {
  final budgetRepository = ref.watch(budgetRepositoryProvider);
  return BudgetViewModel(budgetRepository);
});
