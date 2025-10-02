import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/entry.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';
import 'package:collection/collection.dart';

// Firestore로부터 실시간 거래 내역 스트림을 제공하는 Provider
final entriesStreamProvider = StreamProvider.autoDispose<List<Entry>>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return entryRepository.getEntries();
});

// 홈 화면 상태를 나타내는 클래스
class HomeState {
  final double monthlyIncome;
  final double monthlyExpense;
  final double monthlyBalance;
  final List<Entry> recentEntries;
  final int streak;

  HomeState({
    this.monthlyIncome = 0.0,
    this.monthlyExpense = 0.0,
    this.monthlyBalance = 0.0,
    this.recentEntries = const [],
    this.streak = 0,
  });
}

// 거래 내역 리스트(Stream)를 기반으로 홈 화면의 상태(HomeState)를 계산하여 제공하는 Provider
final homeStateProvider = Provider.autoDispose<AsyncValue<HomeState>>((ref) {
  final entriesAsyncValue = ref.watch(entriesStreamProvider);

  return entriesAsyncValue.when(
    data: (entries) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0).add(const Duration(days: 1));

      double income = 0;
      double expense = 0;

      for (final entry in entries) {
        if (!entry.date.isBefore(startOfMonth) && entry.date.isBefore(endOfMonth)) {
          if (entry.type == EntryType.income) {
            income += entry.amount;
          } else {
            expense += entry.amount;
          }
        }
      }

      final sortedEntries = List<Entry>.from(entries);
      sortedEntries.sort((a, b) => b.date.compareTo(a.date));

      // Streak 계산 로직
      int calculateStreak(List<Entry> entries) {
        if (entries.isEmpty) return 0;

        final uniqueDates = entries
            .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
            .toSet()
            .toList();
        uniqueDates.sort((a, b) => b.compareTo(a));

        int streak = 0;
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        var startDate = uniqueDates.firstWhereOrNull((date) => date == today || date == yesterday);

        if (startDate != null) {
          streak = 1;
          int index = uniqueDates.indexOf(startDate);
          for (int i = index; i < uniqueDates.length - 1; i++) {
            final current = uniqueDates[i];
            final next = uniqueDates[i + 1];
            if (current.subtract(const Duration(days: 1)) == next) {
              streak++;
            } else {
              break;
            }
          }
        }
        return streak;
      }

      final streak = calculateStreak(entries);

      final homeState = HomeState(
        monthlyIncome: income,
        monthlyExpense: expense,
        monthlyBalance: income - expense,
        recentEntries: sortedEntries.take(10).toList(),
        streak: streak,
      );

      return AsyncData(homeState);
    },
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
});
