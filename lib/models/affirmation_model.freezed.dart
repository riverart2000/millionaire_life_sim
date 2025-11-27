// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'affirmation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AffirmationModel _$AffirmationModelFromJson(Map<String, dynamic> json) {
  return _AffirmationModel.fromJson(json);
}

/// @nodoc
mixin _$AffirmationModel {
  String get id => throw _privateConstructorUsedError;
  String get fullText => throw _privateConstructorUsedError;
  List<String> get words => throw _privateConstructorUsedError;
  List<int> get blankIndices => throw _privateConstructorUsedError;
  List<String> get userAnswers => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AffirmationModelCopyWith<AffirmationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AffirmationModelCopyWith<$Res> {
  factory $AffirmationModelCopyWith(
          AffirmationModel value, $Res Function(AffirmationModel) then) =
      _$AffirmationModelCopyWithImpl<$Res, AffirmationModel>;
  @useResult
  $Res call(
      {String id,
      String fullText,
      List<String> words,
      List<int> blankIndices,
      List<String> userAnswers,
      bool completed,
      int attempts});
}

/// @nodoc
class _$AffirmationModelCopyWithImpl<$Res, $Val extends AffirmationModel>
    implements $AffirmationModelCopyWith<$Res> {
  _$AffirmationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullText = null,
    Object? words = null,
    Object? blankIndices = null,
    Object? userAnswers = null,
    Object? completed = null,
    Object? attempts = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullText: null == fullText
          ? _value.fullText
          : fullText // ignore: cast_nullable_to_non_nullable
              as String,
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as List<String>,
      blankIndices: null == blankIndices
          ? _value.blankIndices
          : blankIndices // ignore: cast_nullable_to_non_nullable
              as List<int>,
      userAnswers: null == userAnswers
          ? _value.userAnswers
          : userAnswers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AffirmationModelImplCopyWith<$Res>
    implements $AffirmationModelCopyWith<$Res> {
  factory _$$AffirmationModelImplCopyWith(_$AffirmationModelImpl value,
          $Res Function(_$AffirmationModelImpl) then) =
      __$$AffirmationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fullText,
      List<String> words,
      List<int> blankIndices,
      List<String> userAnswers,
      bool completed,
      int attempts});
}

/// @nodoc
class __$$AffirmationModelImplCopyWithImpl<$Res>
    extends _$AffirmationModelCopyWithImpl<$Res, _$AffirmationModelImpl>
    implements _$$AffirmationModelImplCopyWith<$Res> {
  __$$AffirmationModelImplCopyWithImpl(_$AffirmationModelImpl _value,
      $Res Function(_$AffirmationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullText = null,
    Object? words = null,
    Object? blankIndices = null,
    Object? userAnswers = null,
    Object? completed = null,
    Object? attempts = null,
  }) {
    return _then(_$AffirmationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullText: null == fullText
          ? _value.fullText
          : fullText // ignore: cast_nullable_to_non_nullable
              as String,
      words: null == words
          ? _value._words
          : words // ignore: cast_nullable_to_non_nullable
              as List<String>,
      blankIndices: null == blankIndices
          ? _value._blankIndices
          : blankIndices // ignore: cast_nullable_to_non_nullable
              as List<int>,
      userAnswers: null == userAnswers
          ? _value._userAnswers
          : userAnswers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AffirmationModelImpl
    with DiagnosticableTreeMixin
    implements _AffirmationModel {
  const _$AffirmationModelImpl(
      {required this.id,
      required this.fullText,
      required final List<String> words,
      required final List<int> blankIndices,
      final List<String> userAnswers = const [],
      this.completed = false,
      this.attempts = 0})
      : _words = words,
        _blankIndices = blankIndices,
        _userAnswers = userAnswers;

  factory _$AffirmationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AffirmationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullText;
  final List<String> _words;
  @override
  List<String> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  final List<int> _blankIndices;
  @override
  List<int> get blankIndices {
    if (_blankIndices is EqualUnmodifiableListView) return _blankIndices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blankIndices);
  }

  final List<String> _userAnswers;
  @override
  @JsonKey()
  List<String> get userAnswers {
    if (_userAnswers is EqualUnmodifiableListView) return _userAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userAnswers);
  }

  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final int attempts;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AffirmationModel(id: $id, fullText: $fullText, words: $words, blankIndices: $blankIndices, userAnswers: $userAnswers, completed: $completed, attempts: $attempts)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AffirmationModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('fullText', fullText))
      ..add(DiagnosticsProperty('words', words))
      ..add(DiagnosticsProperty('blankIndices', blankIndices))
      ..add(DiagnosticsProperty('userAnswers', userAnswers))
      ..add(DiagnosticsProperty('completed', completed))
      ..add(DiagnosticsProperty('attempts', attempts));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AffirmationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullText, fullText) ||
                other.fullText == fullText) &&
            const DeepCollectionEquality().equals(other._words, _words) &&
            const DeepCollectionEquality()
                .equals(other._blankIndices, _blankIndices) &&
            const DeepCollectionEquality()
                .equals(other._userAnswers, _userAnswers) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullText,
      const DeepCollectionEquality().hash(_words),
      const DeepCollectionEquality().hash(_blankIndices),
      const DeepCollectionEquality().hash(_userAnswers),
      completed,
      attempts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AffirmationModelImplCopyWith<_$AffirmationModelImpl> get copyWith =>
      __$$AffirmationModelImplCopyWithImpl<_$AffirmationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AffirmationModelImplToJson(
      this,
    );
  }
}

abstract class _AffirmationModel implements AffirmationModel {
  const factory _AffirmationModel(
      {required final String id,
      required final String fullText,
      required final List<String> words,
      required final List<int> blankIndices,
      final List<String> userAnswers,
      final bool completed,
      final int attempts}) = _$AffirmationModelImpl;

  factory _AffirmationModel.fromJson(Map<String, dynamic> json) =
      _$AffirmationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullText;
  @override
  List<String> get words;
  @override
  List<int> get blankIndices;
  @override
  List<String> get userAnswers;
  @override
  bool get completed;
  @override
  int get attempts;
  @override
  @JsonKey(ignore: true)
  _$$AffirmationModelImplCopyWith<_$AffirmationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AffirmationProgress _$AffirmationProgressFromJson(Map<String, dynamic> json) {
  return _AffirmationProgress.fromJson(json);
}

/// @nodoc
mixin _$AffirmationProgress {
  int get totalAffirmations => throw _privateConstructorUsedError;
  int get completedAffirmations => throw _privateConstructorUsedError;
  Map<String, bool> get completedIds => throw _privateConstructorUsedError;
  DateTime? get lastPracticeDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AffirmationProgressCopyWith<AffirmationProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AffirmationProgressCopyWith<$Res> {
  factory $AffirmationProgressCopyWith(
          AffirmationProgress value, $Res Function(AffirmationProgress) then) =
      _$AffirmationProgressCopyWithImpl<$Res, AffirmationProgress>;
  @useResult
  $Res call(
      {int totalAffirmations,
      int completedAffirmations,
      Map<String, bool> completedIds,
      DateTime? lastPracticeDate});
}

/// @nodoc
class _$AffirmationProgressCopyWithImpl<$Res, $Val extends AffirmationProgress>
    implements $AffirmationProgressCopyWith<$Res> {
  _$AffirmationProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAffirmations = null,
    Object? completedAffirmations = null,
    Object? completedIds = null,
    Object? lastPracticeDate = freezed,
  }) {
    return _then(_value.copyWith(
      totalAffirmations: null == totalAffirmations
          ? _value.totalAffirmations
          : totalAffirmations // ignore: cast_nullable_to_non_nullable
              as int,
      completedAffirmations: null == completedAffirmations
          ? _value.completedAffirmations
          : completedAffirmations // ignore: cast_nullable_to_non_nullable
              as int,
      completedIds: null == completedIds
          ? _value.completedIds
          : completedIds // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      lastPracticeDate: freezed == lastPracticeDate
          ? _value.lastPracticeDate
          : lastPracticeDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AffirmationProgressImplCopyWith<$Res>
    implements $AffirmationProgressCopyWith<$Res> {
  factory _$$AffirmationProgressImplCopyWith(_$AffirmationProgressImpl value,
          $Res Function(_$AffirmationProgressImpl) then) =
      __$$AffirmationProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalAffirmations,
      int completedAffirmations,
      Map<String, bool> completedIds,
      DateTime? lastPracticeDate});
}

/// @nodoc
class __$$AffirmationProgressImplCopyWithImpl<$Res>
    extends _$AffirmationProgressCopyWithImpl<$Res, _$AffirmationProgressImpl>
    implements _$$AffirmationProgressImplCopyWith<$Res> {
  __$$AffirmationProgressImplCopyWithImpl(_$AffirmationProgressImpl _value,
      $Res Function(_$AffirmationProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAffirmations = null,
    Object? completedAffirmations = null,
    Object? completedIds = null,
    Object? lastPracticeDate = freezed,
  }) {
    return _then(_$AffirmationProgressImpl(
      totalAffirmations: null == totalAffirmations
          ? _value.totalAffirmations
          : totalAffirmations // ignore: cast_nullable_to_non_nullable
              as int,
      completedAffirmations: null == completedAffirmations
          ? _value.completedAffirmations
          : completedAffirmations // ignore: cast_nullable_to_non_nullable
              as int,
      completedIds: null == completedIds
          ? _value._completedIds
          : completedIds // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      lastPracticeDate: freezed == lastPracticeDate
          ? _value.lastPracticeDate
          : lastPracticeDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AffirmationProgressImpl
    with DiagnosticableTreeMixin
    implements _AffirmationProgress {
  const _$AffirmationProgressImpl(
      {this.totalAffirmations = 0,
      this.completedAffirmations = 0,
      final Map<String, bool> completedIds = const {},
      this.lastPracticeDate})
      : _completedIds = completedIds;

  factory _$AffirmationProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AffirmationProgressImplFromJson(json);

  @override
  @JsonKey()
  final int totalAffirmations;
  @override
  @JsonKey()
  final int completedAffirmations;
  final Map<String, bool> _completedIds;
  @override
  @JsonKey()
  Map<String, bool> get completedIds {
    if (_completedIds is EqualUnmodifiableMapView) return _completedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completedIds);
  }

  @override
  final DateTime? lastPracticeDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AffirmationProgress(totalAffirmations: $totalAffirmations, completedAffirmations: $completedAffirmations, completedIds: $completedIds, lastPracticeDate: $lastPracticeDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AffirmationProgress'))
      ..add(DiagnosticsProperty('totalAffirmations', totalAffirmations))
      ..add(DiagnosticsProperty('completedAffirmations', completedAffirmations))
      ..add(DiagnosticsProperty('completedIds', completedIds))
      ..add(DiagnosticsProperty('lastPracticeDate', lastPracticeDate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AffirmationProgressImpl &&
            (identical(other.totalAffirmations, totalAffirmations) ||
                other.totalAffirmations == totalAffirmations) &&
            (identical(other.completedAffirmations, completedAffirmations) ||
                other.completedAffirmations == completedAffirmations) &&
            const DeepCollectionEquality()
                .equals(other._completedIds, _completedIds) &&
            (identical(other.lastPracticeDate, lastPracticeDate) ||
                other.lastPracticeDate == lastPracticeDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalAffirmations,
      completedAffirmations,
      const DeepCollectionEquality().hash(_completedIds),
      lastPracticeDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AffirmationProgressImplCopyWith<_$AffirmationProgressImpl> get copyWith =>
      __$$AffirmationProgressImplCopyWithImpl<_$AffirmationProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AffirmationProgressImplToJson(
      this,
    );
  }
}

abstract class _AffirmationProgress implements AffirmationProgress {
  const factory _AffirmationProgress(
      {final int totalAffirmations,
      final int completedAffirmations,
      final Map<String, bool> completedIds,
      final DateTime? lastPracticeDate}) = _$AffirmationProgressImpl;

  factory _AffirmationProgress.fromJson(Map<String, dynamic> json) =
      _$AffirmationProgressImpl.fromJson;

  @override
  int get totalAffirmations;
  @override
  int get completedAffirmations;
  @override
  Map<String, bool> get completedIds;
  @override
  DateTime? get lastPracticeDate;
  @override
  @JsonKey(ignore: true)
  _$$AffirmationProgressImplCopyWith<_$AffirmationProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
