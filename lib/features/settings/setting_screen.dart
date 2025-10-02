import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/providers.dart';
import 'package:so_vuon/features/category/category_management_screen.dart';
import 'package:so_vuon/features/settings/settings_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsViewModel = ref.read(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('카테고리 관리'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryManagementScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('데이터 백업'),
            onTap: () async {
              await settingsViewModel.backupData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터 백업이 완료되었습니다.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('데이터 복원'),
            onTap: () async {
              await settingsViewModel.restoreData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터 복원이 완료되었습니다.')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () async {
              await ref.read(userRepositoryProvider).signOut();
            },
          ),
        ],
      ),
    );
  }
}
