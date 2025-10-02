import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_item.freezed.dart';
part 'store_item.g.dart';

enum ItemType { theme, plant, decoration }

@freezed
class StoreItem with _$StoreItem {
  const factory StoreItem({
    required String id,
    required String name,
    required String description,
    required double price,
    required ItemType type,
    required String assetPath,
    @Default(false) bool isPremiumOnly,
  }) = _StoreItem;

  factory StoreItem.fromJson(Map<String, dynamic> json) => _$StoreItemFromJson(json);
}
