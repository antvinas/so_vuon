import 'package:so_vuon/data/models/placed_item.dart';

class GardenState {
  final String id;
  final String userId;
  final int level;
  final int experience;
  final List<PlacedItem> placedItems;
  final DateTime lastUpdated;

  GardenState({
    required this.id,
    required this.userId,
    required this.level,
    required this.experience,
    required this.placedItems,
    required this.lastUpdated,
  });
}
