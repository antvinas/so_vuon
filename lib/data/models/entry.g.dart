// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryImpl _$$EntryImplFromJson(Map<String, dynamic> json) => _$EntryImpl(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      memo: json['memo'] as String?,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$EntryTypeEnumMap, json['type']),
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$$EntryImplToJson(_$EntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'category': instance.category,
      'memo': instance.memo,
      'date': instance.date.toIso8601String(),
      'type': _$EntryTypeEnumMap[instance.type]!,
      'photoUrl': instance.photoUrl,
    };

const _$EntryTypeEnumMap = {
  EntryType.expense: 'expense',
  EntryType.income: 'income',
};
