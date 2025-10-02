import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/providers.dart';
import 'package:so_vuon/data/models/entry.dart';

class EntryRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  EntryRepository(this._firestore, this._uid);

  // 지출/수입 내역 스트림 가져오기
  Stream<List<Entry>> getEntries() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('entries')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final entry = Entry.fromJson(doc.data());
        return entry.copyWith(id: doc.id);
      }).toList();
    });
  }

  // 특정 내역 가져오기 (이 부분은 현재 사용되지 않지만, 수정을 위해 남겨둡니다)
  Future<Entry> getEntry(String id) async {
    final doc = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('entries')
        .doc(id)
        .get();
    final entry = Entry.fromJson(doc.data()!);
    return entry.copyWith(id: doc.id);
  }

  // 내역 추가
  Future<void> addEntry(Entry entry) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('entries')
        .add(entry.toJson());
  }

  // 내역 수정
  Future<void> updateEntry(Entry entry) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('entries')
        .doc(entry.id)
        .update(entry.toJson());
  }

  // 내역 삭제
  Future<void> deleteEntry(String id) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('entries')
        .doc(id)
        .delete();
  }
}

// EntryRepository 프로바이더
final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final uid = ref.watch(uidProvider);
  if (uid == null) {
    throw Exception('User is not logged in');
  }
  return EntryRepository(firestore, uid);
});
