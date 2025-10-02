// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreItemImpl _$$StoreItemImplFromJson(Map<String, dynamic> json) =>
    _$StoreItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      assetPath: json['assetPath'] as String,
      isPremiumOnly: json['isPremiumOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoreItemImplToJson(_$StoreItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'assetPath': instance.assetPath,
      'isPremiumOnly': instance.isPremiumOnly,
    };

const _$ItemTypeEnumMap = {
  ItemType.theme: 'theme',
  ItemType.plant: 'plant',
  ItemType.decoration: 'decoration',
};
