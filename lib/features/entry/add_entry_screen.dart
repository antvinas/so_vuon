import 'package:flutter/material.dart';

class AddEntryScreen extends StatelessWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지출 기록'),
      ),
      body: const Center(
        child: Text('지출 입력 화면입니다.'),
      ),
    );
  }
}
