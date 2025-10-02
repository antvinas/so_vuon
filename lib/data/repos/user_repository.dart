import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _auth;

  UserRepository(this._auth);

  // 익명으로 로그인
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      // 에러 처리 (예: 로그 출력)
      print('익명 로그인 실패: $e');
      return null;
    }
  }

  // 현재 사용자 가져오기
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      print('계정 삭제 실패: $e');
      // TODO: 재인증이 필요한 경우와 같은 특정 오류 처리
      rethrow; 
    }
  }
}
