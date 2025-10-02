import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/entry.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';

// 이 ViewModel은 거래 내역 추가/수정/삭제와 같은 개별 동작을 처리합니다.
class EntryViewModel extends StateNotifier<AsyncValue<void>> {
  final EntryRepository _entryRepository;

  EntryViewModel(this._entryRepository) : super(const AsyncData(null));

  Future<void> addEntry({
    required double amount,
    required EntryType type,
    required String category,
    required String description,
    required DateTime date,
  }) async {
    state = const AsyncLoading();
    try {
      final newEntry = Entry(
        // Firestore에서 ID를 자동으로 생성하므로, 여기서 id는 임시값입니다.
        id: '',
        amount: amount,
        type: type,
        date: date,
        category: category,
        description: description,
      );

      // EntryRepository를 통해 Firestore에 데이터를 추가합니다.
      await _entryRepository.addEntry(newEntry);

      state = const AsyncData(null); // 성공
    } catch (e, st) {
      state = AsyncError(e, st); // 실패
    }
  }
}

// 이제 Provider는 EntryRepository를 주입받아 EntryViewModel을 생성합니다.
final entryViewModelProvider = StateNotifierProvider.autoDispose<EntryViewModel, AsyncValue<void>>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return EntryViewModel(entryRepository);
});
