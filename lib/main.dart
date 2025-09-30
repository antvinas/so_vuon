import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sổ Vườn',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _writeTest() async {
    await FirebaseFirestore.instance
        .collection('test')
        .doc('hello')
        .set({'msg': 'hi', 'time': DateTime.now().toIso8601String()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore 연결 테스트')),
      body: const Center(child: Text('버튼 누르면 Firestore에 문서 생성')),
      floatingActionButton: FloatingActionButton(
        onPressed: _writeTest,
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
