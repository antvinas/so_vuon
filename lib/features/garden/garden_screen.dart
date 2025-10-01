import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정원')),
      body: const Center(child: Text('정원 화면')),
    );
  }
}