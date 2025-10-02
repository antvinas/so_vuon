import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/repositories/user_repository.dart';

// FirebaseAuth 인스턴스를 제공하는 Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// FirebaseFirestore 인스턴스를 제공하는 Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// UserRepository 인스턴스를 제공하는 Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return UserRepository(auth);
});
