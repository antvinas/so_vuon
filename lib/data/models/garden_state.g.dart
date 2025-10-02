// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenStateImpl _$$GardenStateImplFromJson(Map<String, dynamic> json) =>
    _$GardenStateImpl(
      level: (json['level'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      placedItems: (json['placedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentTheme: json['currentTheme'] as String,
    );

Map<String, dynamic> _$$GardenStateImplToJson(_$GardenStateImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'experience': instance.experience,
      'streak': instance.streak,
      'placedItems': instance.placedItems,
      'currentTheme': instance.currentTheme,
    };
