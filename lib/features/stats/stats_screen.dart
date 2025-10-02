import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:so_vuon/core/theme/colors.dart';

// 샘플 데이터
final Map<String, double> categoryData = {
  '식비': 45,
  '교통': 20,
  '쇼핑': 15,
  '문화생활': 10,
  '기타': 10,
};

final List<FlSpot> weeklySpending = [
  const FlSpot(0, 50000), // 월
  const FlSpot(1, 70000),
  const FlSpot(2, 30000),
  const FlSpot(3, 90000),
  const FlSpot(4, 45000),
  const FlSpot(5, 60000),
  const FlSpot(6, 25000), // 일
];

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지출 통계'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '주간'),
            Tab(text: '월간'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('카테고리별 지출', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                sections: _buildPieChartSections(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              )),
            ),
            const SizedBox(height: 32),
            Text('지출 추이', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(_buildLineChartData()),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return categoryData.entries.map((entry) {
      final isTouched = false; // 터치 인터랙션 (추후 구현)
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: SoVuonColors.fromCategory(entry.key),
        value: entry.value,
        title: '${entry.value}%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: weeklySpending,
          isCurved: true,
          color: Theme.of(context).primaryColor,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
