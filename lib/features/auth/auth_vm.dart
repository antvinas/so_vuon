import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:so_vuon/core/providers.dart';

// 인증 상태를 관리하는 StateNotifier
class AuthViewModel extends StateNotifier<User?> {
  final Ref _ref;

  AuthViewModel(this._ref) : super(null) {
    // 앱 시작 시 현재 사용자 확인
    state = _ref.read(userRepositoryProvider).getCurrentUser();
    // 인증 상태 변경 감지
    _ref.read(firebaseAuthProvider).authStateChanges().listen((user) {
      state = user;
    });
    // 앱 시작 시 익명 로그인 시도
    signInAnonymously();
  }

  // 익명 로그인
  Future<void> signInAnonymously() async {
    await _ref.read(userRepositoryProvider).signInAnonymously();
  }

  // 로그아웃
  Future<void> signOut() async {
    await _ref.read(userRepositoryProvider).signOut();
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    await _ref.read(userRepositoryProvider).deleteAccount();
  }
}

// AuthViewModel을 제공하는 StateNotifierProvider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, User?>((ref) {
  return AuthViewModel(ref);
});
