import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/budget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  BudgetRepository(this._firestore, this._auth);

  Stream<List<Budget>> getBudgets() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Budget.fromJson(doc.data()))
            .toList());
  }

  Future<void> addBudget(Budget budget) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .doc(budget.id);
    return docRef.set(budget.toJson());
  }

  Future<void> updateBudget(Budget budget) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .doc(budget.id);
    return docRef.update(budget.toJson());
  }

  Future<void> deleteBudget(String budgetId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .doc(budgetId)
        .delete();
  }
}

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});
