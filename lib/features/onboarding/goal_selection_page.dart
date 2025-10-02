import 'package:flutter/material.dart';

class GoalSelectionPage extends StatelessWidget {
  final Function(String) onGoalSelected;

  const GoalSelectionPage({super.key, required this.onGoalSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '목표 설정하기',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Sổ Vườn과 함께 달성하고 싶은 목표를 선택해주세요.',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildGoalOption(context, '무지출 챌린지', '한 달 동안 불필요한 지출 없이 살아남기'),
          const SizedBox(height: 16),
          _buildGoalOption(context, '절약 습관 형성', '매일, 매주 꾸준히 지출을 기록하고 관리하기'),
          const SizedBox(height: 16),
          _buildGoalOption(context, '자산 관리 시작', '나의 소비 패턴을 파악하고 자산 관리 시작하기'),
        ],
      ),
    );
  }

  Widget _buildGoalOption(BuildContext context, String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () => onGoalSelected(title),
      ),
    );
  }
}
