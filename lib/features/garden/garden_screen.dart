import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/features/garden/garden_vm.dart';

class GardenScreen extends ConsumerWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gardenState = ref.watch(gardenViewModelProvider);

    // 임시 아이템-이모지 매핑
    final itemEmojiMap = {
      'tree_1': '🌳',
      'flower_1': '🌸',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 정원'),
        actions: [
          IconButton(
            icon: const Icon(Icons.store_outlined),
            onPressed: () {
              // TODO: Navigate to Store Screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Garden State Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${gardenState.level}', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    // Experience Bar
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                           width: MediaQuery.of(context).size.width * 0.6 * (gardenState.experience / 100),
                           decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                           ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('🔥', style: theme.textTheme.headlineSmall),
                    // TODO: Replace with actual streak data
                    Text('3일 연속', style: theme.textTheme.bodySmall),
                  ],
                )
              ],
            ),
          ),
          
          // 2. Garden Visualization
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/garden_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: gardenState.placedItems.map((item) {
                  return Positioned(
                    left: item.x,
                    top: item.y,
                    child: Text(
                      itemEmojiMap[item.itemId] ?? '❔', 
                      style: const TextStyle(fontSize: 40)
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
