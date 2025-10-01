import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:so_vuon/features/home/home_screen.dart';
import 'package:so_vuon/features/onboarding/onboarding_screen.dart'; // 온보딩 화면 (추후 구현)
import 'package:so_vuon/features/entry/add_entry_screen.dart'; // 지출 입력 화면 (추후 구현)

// 라우터 설정을 위한 GoRouter 인스턴스 생성
final GoRouter appRouter = GoRouter(
  initialLocation: '/', // 앱 시작 시 첫 경로
  routes: <RouteBase>[
    // 홈 화면 라우트
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen(); // 홈 화면을 기본 페이지로 설정
      },
      routes: <RouteBase>[
        // 지출 입력 화면 (세부 경로)
        GoRoute(
          path: 'entry/add',
          // 페이지 전환 애니메이션을 커스텀하기 위해 PageBuilder 사용
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const AddEntryScreen(), // 지출 입력 화면 위젯
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                // 아래에서 위로 올라오는 슬라이드 애니메이션
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    // 온보딩 화면 라우트 (추후 사용)
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
  ],
  // 에러 발생 시 보여줄 화면 (옵션)
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다.\n${state.error}'),
    ),
  ),
);
