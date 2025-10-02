import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';
import 'package:so_vuon/features/statistics/category_statistics_vm.dart';
import 'package:so_vuon/features/statistics/statistics_vm.dart';
import 'dart:math';

import 'package:so_vuon/features/stats/charts/spending_chart.dart';

// Provider for daily spending data for the line chart
final dailySpendingChartProvider = StreamProvider<List<FlSpot>>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return entryRepository.getEntries().map((entries) {
    if (entries.isEmpty) return [];

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final recentEntries = entries.where((e) => e.date.isAfter(thirtyDaysAgo)).toList();

    Map<int, double> dailyTotals = {};
    for (var entry in recentEntries) {
      final day = now.difference(entry.date).inDays;
      dailyTotals.update(day, (value) => value + entry.amount, ifAbsent: () => entry.amount);
    }

    return List.generate(30, (index) {
      final day = 29 - index;
      return FlSpot(day.toDouble(), dailyTotals[day] ?? 0);
    });
  });
});

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  Color _getColorFromCategory(String category) {
    final hash = category.hashCode;
    final random = Random(hash);
    return Color.fromARGB(
      255,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyTotalsAsync = ref.watch(statisticsViewModelProvider);
    final categoryTotalsAsync = ref.watch(categoryStatisticsViewModelProvider);
    final dailySpendingAsync = ref.watch(dailySpendingChartProvider);
    final locale = Localizations.localeOf(context);
    final currencyFormat = NumberFormat.currency(locale: locale.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context, '요약'),
          monthlyTotalsAsync.when(
            data: (monthlyTotals) => _buildSummary(context, monthlyTotals, currencyFormat),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('요약 데이터를 불러오는 중 오류가 발생했습니다: $error')),
          ),
          const Divider(),
          _buildSectionTitle(context, '최근 30일 지출'),
          SizedBox(
            height: 200,
            child: dailySpendingAsync.when(
              data: (spots) => spots.isEmpty
                  ? const Center(child: Text('최근 지출 내역이 없습니다.'))
                  : SpendingChart(spots: spots),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('차트 데이터를 불러오는 중 오류가 발생했습니다: $error')),
            ),
          ),
          const Divider(),
          _buildSectionTitle(context, '카테고리별 지출'),
          SizedBox(
            height: 250,
            child: categoryTotalsAsync.when(
              data: (categoryTotals) => _buildPieChart(categoryTotals),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('차트 데이터를 불러오는 중 오류가 발생했습니다: $error')),
            ),
          ),
          const Divider(thickness: 2),
          _buildSectionTitle(context, '월별 지출'),
          monthlyTotalsAsync.when(
            data: (monthlyTotals) => _buildMonthlyList(monthlyTotals, currencyFormat),
            loading: () => const SizedBox.shrink(), // Summary section already shows a loader
            error: (error, stack) => Center(child: Text('월별 내역을 불러오는 중 오류가 발생했습니다: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, Map<String, double> monthlyTotals, NumberFormat currencyFormat) {
    if (monthlyTotals.length < 2) {
      return const ListTile(title: Text('비교할 데이터가 부족합니다.'));
    }

    final currentMonthTotal = monthlyTotals.values.first;
    final previousMonthTotal = monthlyTotals.values.elementAt(1);
    final difference = currentMonthTotal - previousMonthTotal;
    final percentageChange = previousMonthTotal == 0 ? 100.0 : (difference / previousMonthTotal) * 100;

    final isIncrease = difference > 0;
    final color = isIncrease ? Colors.red : Colors.blue;
    final icon = isIncrease ? Icons.arrow_upward : Icons.arrow_downward;

    return ListTile(
      title: Text('전월 대비', style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        '${currencyFormat.format(difference.abs())} (${percentageChange.toStringAsFixed(1)}%)',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
      trailing: Icon(icon, color: color, size: 32),
    );
  }

  Widget _buildPieChart(Map<String, double> categoryTotals) {
    if (categoryTotals.isEmpty) {
      return const Center(child: Text('지출 내역이 없습니다.'));
    }
    return PieChart(
      PieChartData(
        sections: categoryTotals.entries.map((data) {
          return PieChartSectionData(
            color: _getColorFromCategory(data.key),
            value: data.value,
            title: data.key,
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          );
        }).toList(),
      ),
      options: const PieChartOptions(centerSpaceRadius: 40),
    );
  }

  Widget _buildMonthlyList(Map<String, double> monthlyTotals, NumberFormat currencyFormat) {
    if (monthlyTotals.isEmpty) {
      return const Center(child: Text('지출 내역이 없습니다.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: monthlyTotals.length,
      itemBuilder: (context, index) {
        final month = monthlyTotals.keys.elementAt(index);
        final total = monthlyTotals.values.elementAt(index);
        return ListTile(
          title: Text(month),
          trailing: Text(currencyFormat.format(total)),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
