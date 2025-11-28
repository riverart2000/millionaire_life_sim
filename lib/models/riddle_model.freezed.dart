// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riddle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Riddle _$RiddleFromJson(Map<String, dynamic> json) {
  return _Riddle.fromJson(json);
}

/// @nodoc
mixin _$Riddle {
  String get id => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get riddle => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  @JsonKey(name: 'correct_option_index')
  int get correctOptionIndex => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RiddleCopyWith<Riddle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiddleCopyWith<$Res> {
  factory $RiddleCopyWith(Riddle value, $Res Function(Riddle) then) =
      _$RiddleCopyWithImpl<$Res, Riddle>;
  @useResult
  $Res call(
      {String id,
      String difficulty,
      List<String> tags,
      String riddle,
      List<String> options,
      @JsonKey(name: 'correct_option_index') int correctOptionIndex,
      String answer,
      String explanation});
}

/// @nodoc
class _$RiddleCopyWithImpl<$Res, $Val extends Riddle>
    implements $RiddleCopyWith<$Res> {
  _$RiddleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? difficulty = null,
    Object? tags = null,
    Object? riddle = null,
    Object? options = null,
    Object? correctOptionIndex = null,
    Object? answer = null,
    Object? explanation = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      riddle: null == riddle
          ? _value.riddle
          : riddle // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctOptionIndex: null == correctOptionIndex
          ? _value.correctOptionIndex
          : correctOptionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiddleImplCopyWith<$Res> implements $RiddleCopyWith<$Res> {
  factory _$$RiddleImplCopyWith(
          _$RiddleImpl value, $Res Function(_$RiddleImpl) then) =
      __$$RiddleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String difficulty,
      List<String> tags,
      String riddle,
      List<String> options,
      @JsonKey(name: 'correct_option_index') int correctOptionIndex,
      String answer,
      String explanation});
}

/// @nodoc
class __$$RiddleImplCopyWithImpl<$Res>
    extends _$RiddleCopyWithImpl<$Res, _$RiddleImpl>
    implements _$$RiddleImplCopyWith<$Res> {
  __$$RiddleImplCopyWithImpl(
      _$RiddleImpl _value, $Res Function(_$RiddleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? difficulty = null,
    Object? tags = null,
    Object? riddle = null,
    Object? options = null,
    Object? correctOptionIndex = null,
    Object? answer = null,
    Object? explanation = null,
  }) {
    return _then(_$RiddleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      riddle: null == riddle
          ? _value.riddle
          : riddle // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctOptionIndex: null == correctOptionIndex
          ? _value.correctOptionIndex
          : correctOptionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiddleImpl implements _Riddle {
  const _$RiddleImpl(
      {required this.id,
      required this.difficulty,
      required final List<String> tags,
      required this.riddle,
      required final List<String> options,
      @JsonKey(name: 'correct_option_index') required this.correctOptionIndex,
      required this.answer,
      required this.explanation})
      : _tags = tags,
        _options = options;

  factory _$RiddleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiddleImplFromJson(json);

  @override
  final String id;
  @override
  final String difficulty;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String riddle;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey(name: 'correct_option_index')
  final int correctOptionIndex;
  @override
  final String answer;
  @override
  final String explanation;

  @override
  String toString() {
    return 'Riddle(id: $id, difficulty: $difficulty, tags: $tags, riddle: $riddle, options: $options, correctOptionIndex: $correctOptionIndex, answer: $answer, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiddleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.riddle, riddle) || other.riddle == riddle) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctOptionIndex, correctOptionIndex) ||
                other.correctOptionIndex == correctOptionIndex) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      difficulty,
      const DeepCollectionEquality().hash(_tags),
      riddle,
      const DeepCollectionEquality().hash(_options),
      correctOptionIndex,
      answer,
      explanation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RiddleImplCopyWith<_$RiddleImpl> get copyWith =>
      __$$RiddleImplCopyWithImpl<_$RiddleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiddleImplToJson(
      this,
    );
  }
}

abstract class _Riddle implements Riddle {
  const factory _Riddle(
      {required final String id,
      required final String difficulty,
      required final List<String> tags,
      required final String riddle,
      required final List<String> options,
      @JsonKey(name: 'correct_option_index')
      required final int correctOptionIndex,
      required final String answer,
      required final String explanation}) = _$RiddleImpl;

  factory _Riddle.fromJson(Map<String, dynamic> json) = _$RiddleImpl.fromJson;

  @override
  String get id;
  @override
  String get difficulty;
  @override
  List<String> get tags;
  @override
  String get riddle;
  @override
  List<String> get options;
  @override
  @JsonKey(name: 'correct_option_index')
  int get correctOptionIndex;
  @override
  String get answer;
  @override
  String get explanation;
  @override
  @JsonKey(ignore: true)
  _$$RiddleImplCopyWith<_$RiddleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RiddleCategory _$RiddleCategoryFromJson(Map<String, dynamic> json) {
  return _RiddleCategory.fromJson(json);
}

/// @nodoc
mixin _$RiddleCategory {
  String get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<Riddle> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RiddleCategoryCopyWith<RiddleCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiddleCategoryCopyWith<$Res> {
  factory $RiddleCategoryCopyWith(
          RiddleCategory value, $Res Function(RiddleCategory) then) =
      _$RiddleCategoryCopyWithImpl<$Res, RiddleCategory>;
  @useResult
  $Res call({String category, String description, List<Riddle> items});
}

/// @nodoc
class _$RiddleCategoryCopyWithImpl<$Res, $Val extends RiddleCategory>
    implements $RiddleCategoryCopyWith<$Res> {
  _$RiddleCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? description = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Riddle>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiddleCategoryImplCopyWith<$Res>
    implements $RiddleCategoryCopyWith<$Res> {
  factory _$$RiddleCategoryImplCopyWith(_$RiddleCategoryImpl value,
          $Res Function(_$RiddleCategoryImpl) then) =
      __$$RiddleCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String description, List<Riddle> items});
}

/// @nodoc
class __$$RiddleCategoryImplCopyWithImpl<$Res>
    extends _$RiddleCategoryCopyWithImpl<$Res, _$RiddleCategoryImpl>
    implements _$$RiddleCategoryImplCopyWith<$Res> {
  __$$RiddleCategoryImplCopyWithImpl(
      _$RiddleCategoryImpl _value, $Res Function(_$RiddleCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? description = null,
    Object? items = null,
  }) {
    return _then(_$RiddleCategoryImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Riddle>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiddleCategoryImpl implements _RiddleCategory {
  const _$RiddleCategoryImpl(
      {required this.category,
      required this.description,
      required final List<Riddle> items})
      : _items = items;

  factory _$RiddleCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiddleCategoryImplFromJson(json);

  @override
  final String category;
  @override
  final String description;
  final List<Riddle> _items;
  @override
  List<Riddle> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'RiddleCategory(category: $category, description: $description, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiddleCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category, description,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RiddleCategoryImplCopyWith<_$RiddleCategoryImpl> get copyWith =>
      __$$RiddleCategoryImplCopyWithImpl<_$RiddleCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiddleCategoryImplToJson(
      this,
    );
  }
}

abstract class _RiddleCategory implements RiddleCategory {
  const factory _RiddleCategory(
      {required final String category,
      required final String description,
      required final List<Riddle> items}) = _$RiddleCategoryImpl;

  factory _RiddleCategory.fromJson(Map<String, dynamic> json) =
      _$RiddleCategoryImpl.fromJson;

  @override
  String get category;
  @override
  String get description;
  @override
  List<Riddle> get items;
  @override
  @JsonKey(ignore: true)
  _$$RiddleCategoryImplCopyWith<_$RiddleCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
