// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreItem _$StoreItemFromJson(Map<String, dynamic> json) {
  return _StoreItem.fromJson(json);
}

/// @nodoc
mixin _$StoreItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  ItemType get type => throw _privateConstructorUsedError;
  String get assetPath => throw _privateConstructorUsedError;
  bool get isPremiumOnly => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoreItemCopyWith<StoreItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreItemCopyWith<$Res> {
  factory $StoreItemCopyWith(StoreItem value, $Res Function(StoreItem) then) =
      _$StoreItemCopyWithImpl<$Res, StoreItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double price,
      ItemType type,
      String assetPath,
      bool isPremiumOnly});
}

/// @nodoc
class _$StoreItemCopyWithImpl<$Res, $Val extends StoreItem>
    implements $StoreItemCopyWith<$Res> {
  _$StoreItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? type = null,
    Object? assetPath = null,
    Object? isPremiumOnly = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ItemType,
      assetPath: null == assetPath
          ? _value.assetPath
          : assetPath // ignore: cast_nullable_to_non_nullable
              as String,
      isPremiumOnly: null == isPremiumOnly
          ? _value.isPremiumOnly
          : isPremiumOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreItemImplCopyWith<$Res>
    implements $StoreItemCopyWith<$Res> {
  factory _$$StoreItemImplCopyWith(
          _$StoreItemImpl value, $Res Function(_$StoreItemImpl) then) =
      __$$StoreItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double price,
      ItemType type,
      String assetPath,
      bool isPremiumOnly});
}

/// @nodoc
class __$$StoreItemImplCopyWithImpl<$Res>
    extends _$StoreItemCopyWithImpl<$Res, _$StoreItemImpl>
    implements _$$StoreItemImplCopyWith<$Res> {
  __$$StoreItemImplCopyWithImpl(
      _$StoreItemImpl _value, $Res Function(_$StoreItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? type = null,
    Object? assetPath = null,
    Object? isPremiumOnly = null,
  }) {
    return _then(_$StoreItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ItemType,
      assetPath: null == assetPath
          ? _value.assetPath
          : assetPath // ignore: cast_nullable_to_non_nullable
              as String,
      isPremiumOnly: null == isPremiumOnly
          ? _value.isPremiumOnly
          : isPremiumOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreItemImpl implements _StoreItem {
  const _$StoreItemImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.type,
      required this.assetPath,
      this.isPremiumOnly = false});

  factory _$StoreItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final ItemType type;
  @override
  final String assetPath;
  @override
  @JsonKey()
  final bool isPremiumOnly;

  @override
  String toString() {
    return 'StoreItem(id: $id, name: $name, description: $description, price: $price, type: $type, assetPath: $assetPath, isPremiumOnly: $isPremiumOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.assetPath, assetPath) ||
                other.assetPath == assetPath) &&
            (identical(other.isPremiumOnly, isPremiumOnly) ||
                other.isPremiumOnly == isPremiumOnly));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, price,
      type, assetPath, isPremiumOnly);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreItemImplCopyWith<_$StoreItemImpl> get copyWith =>
      __$$StoreItemImplCopyWithImpl<_$StoreItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreItemImplToJson(
      this,
    );
  }
}

abstract class _StoreItem implements StoreItem {
  const factory _StoreItem(
      {required final String id,
      required final String name,
      required final String description,
      required final double price,
      required final ItemType type,
      required final String assetPath,
      final bool isPremiumOnly}) = _$StoreItemImpl;

  factory _StoreItem.fromJson(Map<String, dynamic> json) =
      _$StoreItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  ItemType get type;
  @override
  String get assetPath;
  @override
  bool get isPremiumOnly;
  @override
  @JsonKey(ignore: true)
  _$$StoreItemImplCopyWith<_$StoreItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
