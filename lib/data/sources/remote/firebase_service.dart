import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/entry.dart';

class FirebaseService {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirebaseService({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // 현재 사용자 ID
  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== 인증 ====================

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ==================== 사용자 프로필 ====================

  Future<void> createUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set({
      ...profile.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromJson({...doc.data()!, 'uid': uid});
  }

  Stream<UserProfile?> watchUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromJson({...doc.data()!, 'uid': uid});
    });
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== 지출/수입 엔트리 ====================

  Future<String> addEntry(Entry entry) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    final month = _formatMonth(entry.entryDate);
    final docRef = _db
        .collection('entries')
        .doc(uid)
        .collection(month)
        .doc();

    await docRef.set({
      ...entry.toJson(),
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<void> updateEntry(String entryId, DateTime entryDate, Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    final month = _formatMonth(entryDate);
    await _db
        .collection('entries')
        .doc(uid)
        .collection(month)
        .doc(entryId)
        .update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteEntry(String entryId, DateTime entryDate) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    final month = _formatMonth(entryDate);
    await _db
        .collection('entries')
        .doc(uid)
        .collection(month)
        .doc(entryId)
        .delete();
  }

  Stream<List<Entry>> watchMonthlyEntries(DateTime date) {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    final month = _formatMonth(date);
    return _db
        .collection('entries')
        .doc(uid)
        .collection(month)
        .orderBy('entryDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => Entry.fromJson({...doc.data(), 'id': doc.id}))
        .toList());
  }

  Future<List<Entry>> getEntriesInRange(DateTime start, DateTime end) async {
    final uid = currentUserId;
    if (uid == null) return [];

    // 여러 달에 걸친 쿼리는 클라이언트에서 병합
    final months = _getMonthsInRange(start, end);
    final allEntries = <Entry>[];

    for (final month in months) {
      final snapshot = await _db
          .collection('entries')
          .doc(uid)
          .collection(month)
          .where('entryDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('entryDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .get();

      allEntries.addAll(
        snapshot.docs.map((doc) => Entry.fromJson({...doc.data(), 'id': doc.id})),
      );
    }

    return allEntries;
  }

  // ==================== 예산 ====================

  Future<void> setBudget(Budget budget) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    await _db
        .collection('budgets')
        .doc(uid)
        .collection(budget.month)
        .doc('budget')
        .set({
      ...budget.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Budget?> getBudget(String month) async {
    final uid = currentUserId;
    if (uid == null) return null;

    final doc = await _db
        .collection('budgets')
        .doc(uid)
        .collection(month)
        .doc('budget')
        .get();

    if (!doc.exists) return null;
    return Budget.fromJson({...doc.data()!, 'id': doc.id});
  }

  Stream<Budget?> watchBudget(String month) {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _db
        .collection('budgets')
        .doc(uid)
        .collection(month)
        .doc('budget')
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return Budget.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  // ==================== 정원 ====================

  Future<GardenState?> getGardenState() async {
    final uid = currentUserId;
    if (uid == null) return null;

    final doc = await _db.collection('garden').doc(uid).collection('state').doc('current').get();
    if (!doc.exists) return null;

    return GardenState.fromJson(doc.data()!);
  }

  Stream<GardenState?> watchGardenState() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _db
        .collection('garden')
        .doc(uid)
        .collection('state')
        .doc('current')
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return GardenState.fromJson(doc.data()!);
    });
  }

  Future<void> updateGardenState(Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    await _db
        .collection('garden')
        .doc(uid)
        .collection('state')
        .doc('current')
        .update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== 스토어 ====================

  Future<List<StoreItem>> getStoreItems() async {
    final snapshot = await _db.collection('store').doc('items').collection('all').get();
    return snapshot.docs
        .map((doc) => StoreItem.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Stream<List<StoreItem>> watchStoreItems() {
    return _db.collection('store').doc('items').collection('all').snapshots().map(
          (snap) => snap.docs
          .map((doc) => StoreItem.fromJson({...doc.data(), 'id': doc.id}))
          .toList(),
    );
  }

  // ==================== CS 티켓 ====================

  Future<String> createTicket(String subject, String message) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    final docRef = _db.collection('tickets').doc(uid).collection('all').doc();
    await docRef.set({
      'subject': subject,
      'message': message,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // ==================== 유틸리티 ====================

  String _formatMonth(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}';
  }

  List<String> _getMonthsInRange(DateTime start, DateTime end) {
    final months = <String>[];
    var current = DateTime(start.year, start.month);
    final endMonth = DateTime(end.year, end.month);

    while (current.isBefore(endMonth) || current.isAtSameMomentAs(endMonth)) {
      months.add(_formatMonth(current));
      current = DateTime(current.year, current.month + 1);
    }

    return months;
  }
}