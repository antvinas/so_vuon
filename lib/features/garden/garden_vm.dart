import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/garden_state.dart';
import 'package:so_vuon/data/models/placed_item.dart';

// 임시 데이터. 추후 실제 데이터 소스와 연결해야 합니다.
final _dummyGardenState = GardenState(
  id: 'user1_garden',
  userId: 'user1',
  level: 5,
  experience: 70,
  placedItems: [
    PlacedItem(itemId: 'tree_1', x: 100, y: 50, placedAt: DateTime.now()),
    PlacedItem(itemId: 'flower_1', x: 250, y: 100, placedAt: DateTime.now()),
  ],
  lastUpdated: DateTime.now(),
);

class GardenViewModel extends StateNotifier<GardenState> {
  GardenViewModel() : super(_dummyGardenState);

  // In the future, methods to update garden state will be added here.
  // For example: void placeItem(String itemId, double x, double y) { ... }
}

final gardenViewModelProvider = StateNotifierProvider<GardenViewModel, GardenState>((ref) {
  return GardenViewModel();
});
