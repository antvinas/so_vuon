// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GardenState _$GardenStateFromJson(Map<String, dynamic> json) {
  return _GardenState.fromJson(json);
}

/// @nodoc
mixin _$GardenState {
  int get level => throw _privateConstructorUsedError;
  int get experience => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  List<String> get placedItems =>
      throw _privateConstructorUsedError; // IDs of placed items
  String get currentTheme => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GardenStateCopyWith<GardenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenStateCopyWith<$Res> {
  factory $GardenStateCopyWith(
          GardenState value, $Res Function(GardenState) then) =
      _$GardenStateCopyWithImpl<$Res, GardenState>;
  @useResult
  $Res call(
      {int level,
      int experience,
      int streak,
      List<String> placedItems,
      String currentTheme});
}

/// @nodoc
class _$GardenStateCopyWithImpl<$Res, $Val extends GardenState>
    implements $GardenStateCopyWith<$Res> {
  _$GardenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? experience = null,
    Object? streak = null,
    Object? placedItems = null,
    Object? currentTheme = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      placedItems: null == placedItems
          ? _value.placedItems
          : placedItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentTheme: null == currentTheme
          ? _value.currentTheme
          : currentTheme // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GardenStateImplCopyWith<$Res>
    implements $GardenStateCopyWith<$Res> {
  factory _$$GardenStateImplCopyWith(
          _$GardenStateImpl value, $Res Function(_$GardenStateImpl) then) =
      __$$GardenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int level,
      int experience,
      int streak,
      List<String> placedItems,
      String currentTheme});
}

/// @nodoc
class __$$GardenStateImplCopyWithImpl<$Res>
    extends _$GardenStateCopyWithImpl<$Res, _$GardenStateImpl>
    implements _$$GardenStateImplCopyWith<$Res> {
  __$$GardenStateImplCopyWithImpl(
      _$GardenStateImpl _value, $Res Function(_$GardenStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? experience = null,
    Object? streak = null,
    Object? placedItems = null,
    Object? currentTheme = null,
  }) {
    return _then(_$GardenStateImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      placedItems: null == placedItems
          ? _value._placedItems
          : placedItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentTheme: null == currentTheme
          ? _value.currentTheme
          : currentTheme // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenStateImpl implements _GardenState {
  const _$GardenStateImpl(
      {required this.level,
      required this.experience,
      required this.streak,
      final List<String> placedItems = const [],
      required this.currentTheme})
      : _placedItems = placedItems;

  factory _$GardenStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenStateImplFromJson(json);

  @override
  final int level;
  @override
  final int experience;
  @override
  final int streak;
  final List<String> _placedItems;
  @override
  @JsonKey()
  List<String> get placedItems {
    if (_placedItems is EqualUnmodifiableListView) return _placedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_placedItems);
  }

// IDs of placed items
  @override
  final String currentTheme;

  @override
  String toString() {
    return 'GardenState(level: $level, experience: $experience, streak: $streak, placedItems: $placedItems, currentTheme: $currentTheme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenStateImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            const DeepCollectionEquality()
                .equals(other._placedItems, _placedItems) &&
            (identical(other.currentTheme, currentTheme) ||
                other.currentTheme == currentTheme));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, level, experience, streak,
      const DeepCollectionEquality().hash(_placedItems), currentTheme);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenStateImplCopyWith<_$GardenStateImpl> get copyWith =>
      __$$GardenStateImplCopyWithImpl<_$GardenStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenStateImplToJson(
      this,
    );
  }
}

abstract class _GardenState implements GardenState {
  const factory _GardenState(
      {required final int level,
      required final int experience,
      required final int streak,
      final List<String> placedItems,
      required final String currentTheme}) = _$GardenStateImpl;

  factory _GardenState.fromJson(Map<String, dynamic> json) =
      _$GardenStateImpl.fromJson;

  @override
  int get level;
  @override
  int get experience;
  @override
  int get streak;
  @override
  List<String> get placedItems;
  @override // IDs of placed items
  String get currentTheme;
  @override
  @JsonKey(ignore: true)
  _$$GardenStateImplCopyWith<_$GardenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
