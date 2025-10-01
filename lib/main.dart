import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:so_vuon/app.dart';
import 'firebase_options.dart'; // FlutterFire CLI가 생성한 파일

void main() async {
  // Flutter 엔진과 위젯 바인딩 초기화
  // main 함수가 async로 선언된 경우 필수
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Riverpod을 사용하기 위해 ProviderScope로 앱을 감싸줍니다.
  runApp(
    const ProviderScope(
      child: SoVuonApp(),
    ),
  );
}
