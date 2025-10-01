import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:so_vuon/core/theme/colors.dart'; // 생성될 파일

// 각 탭에 해당하는 임시 화면 위젯들
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('홈'));
}

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('통계'));
}

class GardenTab extends StatelessWidget {
  const GardenTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('정원'));
}

class StoreTab extends StatelessWidget {
  const StoreTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('스토어'));
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('설정'));
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // FAB에 의해 중앙이 비었으므로, 네비게이션 인덱스와 화면 인덱스를 매칭시켜야 함.
    // 0 -> 0, 1 -> 1, 2(FAB) -> 2, 3 -> 3, 4 -> 4
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
      const HomeTab(),
      const StatsTab(),
      const GardenTab(), // 이 화면은 중앙 버튼으로 표시
      const StoreTab(),
      const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 오타 수정: extend_body -> extendBody
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/entry/add'),
        backgroundColor: SoVuonColors.gardenGreen,
        shape: const CircleBorder(),
        elevation: 2.0,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: SoVuonColors.neutral10.withOpacity(0.95),
        elevation: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(icon: Icons.home_rounded, label: '홈', index: 0),
            _buildNavItem(icon: Icons.bar_chart_rounded, label: '통계', index: 1),
            // FAB 자리를 위한 빈 공간
            const SizedBox(width: 48),
            _buildNavItem(icon: Icons.store_rounded, label: '스토어', index: 3),
            _buildNavItem(icon: Icons.settings_rounded, label: '설정', index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? SoVuonColors.primary : SoVuonColors.neutral60,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? SoVuonColors.primary : SoVuonColors.neutral60,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
