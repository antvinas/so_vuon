import 'package:flutter/material.dart';
import 'package:so_vuon/core/services/local_notification_service.dart';
import 'package:so_vuon/features/settings/settings_screen.dart';
import 'package:so_vuon/features/main_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_vuon/app.dart';
import 'package:so_vuon/features/auth/auth_vm.dart';
import 'package:so_vuon/features/garden/garden_screen.dart';
import 'package:so_vuon/features/home/home_screen.dart';
import 'package:so_vuon/features/onboarding/onboarding_screen.dart';
import 'package:so_vuon/features/onboarding/onboarding_vm.dart';
import 'package:so_vuon/features/statistics/statistics_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive 초기화
  await Hive.initFlutter();
  await Hive.openBox('app_settings');

  // Riverpod 컨테이너 생성 및 서비스 초기화
  final container = ProviderContainer();
  await container.read(localNotificationServiceProvider).init();
  await container.read(localNotificationServiceProvider).requestPermissions();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SovuonAppWithRouter(),
    ),
  );
}

// ... (rest of the file remains the same)

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class SovuonAppWithRouter extends ConsumerWidget {
  const SovuonAppWithRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _setupRouter(ref);
    return SoVuonApp(router: router);
  }

  GoRouter _setupRouter(WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final onboardingVM = ref.watch(onboardingViewModelProvider);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      refreshListenable: GoRouterRefreshStream(ref.read(authViewModelProvider.notifier).stream),
      initialLocation: '/',
      redirect: (context, state) {
        final isAuthenticated = authState != null;
        final isOnboardingCompleted = onboardingVM.isOnboardingCompleted;

        final onOnboarding = state.matchedLocation == '/';

        if (!isAuthenticated && !onOnboarding) {
          return '/';
        }

        if (isAuthenticated && !isOnboardingCompleted && !onOnboarding) {
          return '/';
        }

        if (isAuthenticated && isOnboardingCompleted && onOnboarding) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardingScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/garden',
              builder: (context, state) => const GardenScreen(),
            ),
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
