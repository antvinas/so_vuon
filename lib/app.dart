import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/theme/app_theme.dart';
import 'package:so_vuon/router/app_router.dart';

class SoVuonApp extends ConsumerWidget {
  const SoVuonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Sổ Vườn',
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기

      // 앱 테마 설정
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // 시스템 설정에 따라 테마 변경 (추후 커스텀 가능)

      // 라우터 설정
      routerConfig: appRouter,
    );
  }
}
