import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/sources/remote/firebase_service.dart';
import '../data/repos/entry_repository.dart';
import '../data/repos/budget_repository.dart';
import '../data/repos/garden_repository.dart';
import '../data/repos/user_repository.dart';
import '../data/models/entry.dart';

// ==================== Services ====================

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// ==================== Repositories ====================

final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return EntryRepository(firebaseService);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return BudgetRepository(firebaseService);
});

final gardenRepositoryProvider = Provider<GardenRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return GardenRepository(firebaseService);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return UserRepository(firebaseService);
});

// ==================== Auth ====================

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.uid;
});

// ==================== User Profile ====================

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(null);

  final repo = ref.watch(userRepositoryProvider);
  return repo.watchProfile(userId);
});

// ==================== Entries ====================

final currentMonthEntriesProvider = StreamProvider<List<Entry>>((ref) {
  final repo = ref.watch(entryRepositoryProvider);
  return repo.watchMonthlyEntries(DateTime.now());
});

final monthEntriesProvider = StreamProvider.family<List<Entry>, DateTime>((ref, date) {
  final repo = ref.watch(entryRepositoryProvider);
  return repo.watchMonthlyEntries(date);
});

// ==================== Budget ====================

final currentMonthBudgetProvider = StreamProvider<Budget?>((ref) {
  final now = DateTime.now();
  final month = '${now.year}${now.month.toString().padLeft(2, '0')}';
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchBudget(month);
});

// ==================== Garden ====================

final gardenStateProvider = StreamProvider<GardenState?>((ref) {
  final repo = ref.watch(gardenRepositoryProvider);
  return repo.watchGardenState();
});

// ==================== Stats Calculations ====================

final monthlySpendingProvider = Provider<double>((ref) {
  final entries = ref.watch(currentMonthEntriesProvider);
  return entries.maybeWhen(
    data: (list) => list
        .where((e) => !e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount),
    orElse: () => 0.0,
  );
});

final categoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final entries = ref.watch(currentMonthEntriesProvider);
  return entries.maybeWhen(
    data: (list) {
      final totals = <String, double>{};
      for (final entry in list) {
        if (!entry.isIncome) {
          totals[entry.category] = (totals[entry.category] ?? 0) + entry.amount;
        }
      }
      return totals;
    },
    orElse: () => {},
  );
});

final budgetProgressProvider = Provider<double>((ref) {
  final budget = ref.watch(currentMonthBudgetProvider);
  final spending = ref.watch(monthlySpendingProvider);

  return budget.maybeWhen(
    data: (b) {
      if (b == null || b.totalBudget == 0) return 0.0;
      return spending / b.totalBudget;
    },
    orElse: () => 0.0,
  );
});

// ==================== UI State ====================

/// 로딩 상태 관리
class LoadingState extends StateNotifier<bool> {
  LoadingState() : super(false);

  void setLoading(bool value) => state = value;
}

final loadingProvider = StateNotifierProvider<LoadingState, bool>((ref) {
  return LoadingState();
});

/// 선택된 월 (통계 화면용)
class SelectedMonthNotifier extends StateNotifier<DateTime> {
  SelectedMonthNotifier() : super(DateTime.now());

  void setMonth(DateTime date) => state = date;
  void nextMonth() => state = DateTime(state.year, state.month + 1);
  void previousMonth() => state = DateTime(state.year, state.month - 1);
}

final selectedMonthProvider = StateNotifierProvider<SelectedMonthNotifier, DateTime>((ref) {
  return SelectedMonthNotifier();
});