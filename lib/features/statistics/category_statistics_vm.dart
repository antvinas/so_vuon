import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';

// 1. StateNotifier를 StreamProvider로 변경합니다.
final categoryStatisticsViewModelProvider = StreamProvider<Map<String, double>>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);

  // 2. 스트림을 직접 반환하고, map을 이용해 데이터를 가공합니다.
  return entryRepository.getEntries().map((entries) {
    final categoryTotals = <String, double>{};
    for (var entry in entries) {
      // 3. 카테고리가 없는 경우를 대비하여 기본값을 제공합니다.
      final categoryName = entry.category.isNotEmpty ? entry.category : '미분류';
      categoryTotals.update(categoryName, (value) => value + entry.amount, ifAbsent: () => entry.amount);
    }
    return categoryTotals;
  });
});
