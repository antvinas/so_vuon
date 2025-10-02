import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/entry.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';

// 1. State를 AsyncValue로 변경합니다.
final statisticsViewModelProvider = StreamProvider<Map<String, double>>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  
  // 2. 스트림을 직접 반환하고, map을 이용해 데이터를 가공합니다.
  return entryRepository.getEntries().map((entries) {
    final monthlyTotals = <String, double>{};
    for (var entry in entries) {
      final month = '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}';
      monthlyTotals.update(month, (value) => value + entry.amount, ifAbsent: () => entry.amount);
    }
    // 3. 월별로 정렬하여 반환합니다.
    return Map.fromEntries(monthlyTotals.entries.toList()..sort((a, b) => b.key.compareTo(a.key)));
  });
});
