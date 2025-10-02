import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
class Budget with _$Budget {
  const factory Budget({
    required String id,
    required double amount,
    required String period, // e.g., "monthly", "weekly"
    @Default({}) Map<String, double> categoryBudgets,
    required DateTime startDate,
    required DateTime endDate,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
