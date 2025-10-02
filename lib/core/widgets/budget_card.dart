import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/theme/colors.dart';
import 'package:so_vuon/core/utils/currency_formatter.dart';

class BudgetCard extends ConsumerWidget {
  final double remainingBudget;
  final double totalBudget;
  final String period;

  const BudgetCard({
    super.key,
    required this.remainingBudget,
    required this.totalBudget,
    required this.period,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatterProvider);
    final double progress = totalBudget > 0 ? remainingBudget / totalBudget : 0;
    final Color progressColor = progress > 0.5
        ? SoVuonColors.blue
        : (progress > 0.2 ? SoVuonColors.yellow : SoVuonColors.red);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$period 예산', style: Theme.of(context).textTheme.titleMedium),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Text('남은 금액: ${currencyFormatter.format(remainingBudget)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: SoVuonColors.neutral30,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('총 예산: ${currencyFormatter.format(totalBudget)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
