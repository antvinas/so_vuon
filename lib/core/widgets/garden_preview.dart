import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GardenPreview extends StatelessWidget {
  const GardenPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.go('/garden'), // 정원 화면으로 이동
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 대표 식물 이미지 (추후 Lottie 등으로 변경 가능)
              const Icon(Icons.eco_outlined, size: 50, color: Colors.green),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('내 정원', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('꽃 3그루, 새싹 5그루가 자라고 있어요!', overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
