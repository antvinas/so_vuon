import '../models/entry.dart';
import '../sources/remote/firebase_service.dart';

class EntryRepository {
  final FirebaseService _firebaseService;

  EntryRepository(this._firebaseService);

  Future<String> addEntry(Entry entry) async {
    return await _firebaseService.addEntry(entry);
  }

  Future<void> updateEntry(
      String entryId,
      DateTime entryDate,
      Map<String, dynamic> data,
      ) async {
    await _firebaseService.updateEntry(entryId, entryDate, data);
  }

  Future<void> deleteEntry(String entryId, DateTime entryDate) async {
    await _firebaseService.deleteEntry(entryId, entryDate);
  }

  Stream<List<Entry>> watchMonthlyEntries(DateTime date) {
    return _firebaseService.watchMonthlyEntries(date);
  }

  Future<List<Entry>> getEntriesInRange(DateTime start, DateTime end) async {
    return await _firebaseService.getEntriesInRange(start, end);
  }

  /// 카테고리별 지출 합계 계산
  Future<Map<String, double>> getCategoryTotals(DateTime start, DateTime end) async {
    final entries = await getEntriesInRange(start, end);
    final totals = <String, double>{};

    for (final entry in entries) {
      if (!entry.isIncome) {
        totals[entry.category] = (totals[entry.category] ?? 0) + entry.amount;
      }
    }

    return totals;
  }

  /// 일별 지출 합계
  Future<Map<DateTime, double>> getDailyTotals(DateTime start, DateTime end) async {
    final entries = await getEntriesInRange(start, end);
    final totals = <DateTime, double>{};

    for (final entry in entries) {
      final date = DateTime(
        entry.entryDate.year,
        entry.entryDate.month,
        entry.entryDate.day,
      );

      if (!entry.isIncome) {
        totals[date] = (totals[date] ?? 0) + entry.amount;
      }
    }

    return totals;
  }
}

// lib/data/repos/budget_repository.dart
class BudgetRepository {
  final FirebaseService _firebaseService;

  BudgetRepository(this._firebaseService);

  Future<void> setBudget(Budget budget) async {
    await _firebaseService.setBudget(budget);
  }

  Future<Budget?> getBudget(String month) async {
    return await _firebaseService.getBudget(month);
  }

  Stream<Budget?> watchBudget(String month) {
    return _firebaseService.watchBudget(month);
  }

  Future<Budget?> getCurrentMonthBudget() async {
    final now = DateTime.now();
    final month = '${now.year}${now.month.toString().padLeft(2, '0')}';
    return await getBudget(month);
  }
}

// lib/data/repos/garden_repository.dart
class GardenRepository {
  final FirebaseService _firebaseService;

  GardenRepository(this._firebaseService);

  Future<GardenState?> getGardenState() async {
    return await _firebaseService.getGardenState();
  }

  Stream<GardenState?> watchGardenState() {
    return _firebaseService.watchGardenState();
  }

  Future<void> updateGardenState(Map<String, dynamic> data) async {
    await _firebaseService.updateGardenState(data);
  }

  Future<void> placeItem(PlacedItem item) async {
    final state = await getGardenState();
    if (state == null) return;

    final updatedItems = [...state.placedItems, item];
    await updateGardenState({'placedItems': updatedItems.map((e) => e.toJson()).toList()});
  }

  Future<void> removeItem(String itemId) async {
    final state = await getGardenState();
    if (state == null) return;

    final updatedItems = state.placedItems.where((e) => e.itemId != itemId).toList();
    await updateGardenState({'placedItems': updatedItems.map((e) => e.toJson()).toList()});
  }

  Future<void> unlockItem(String itemId) async {
    final state = await getGardenState();
    if (state == null) return;

    if (!state.unlockedItems.contains(itemId)) {
      final updatedUnlocked = [...state.unlockedItems, itemId];
      await updateGardenState({'unlockedItems': updatedUnlocked});
    }
  }
}

// lib/data/repos/user_repository.dart
class UserRepository {
  final FirebaseService _firebaseService;

  UserRepository(this._firebaseService);

  Future<void> createProfile(UserProfile profile) async {
    await _firebaseService.createUserProfile(profile);
  }

  Future<UserProfile?> getProfile(String uid) async {
    return await _firebaseService.getUserProfile(uid);
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _firebaseService.watchUserProfile(uid);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _firebaseService.updateUserProfile(uid, data);
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
  }
}