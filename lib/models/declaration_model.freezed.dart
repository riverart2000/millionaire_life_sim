// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'declaration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Declaration _$DeclarationFromJson(Map<String, dynamic> json) {
  return _Declaration.fromJson(json);
}

/// @nodoc
mixin _$Declaration {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'declaration', 'answer', 'do'
  String get text => throw _privateConstructorUsedError;
  bool? get requiresAccept => throw _privateConstructorUsedError;
  bool? get requiresInput => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;
  int? get countdownSeconds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeclarationCopyWith<Declaration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeclarationCopyWith<$Res> {
  factory $DeclarationCopyWith(
          Declaration value, $Res Function(Declaration) then) =
      _$DeclarationCopyWithImpl<$Res, Declaration>;
  @useResult
  $Res call(
      {String id,
      String type,
      String text,
      bool? requiresAccept,
      bool? requiresInput,
      String? placeholder,
      int? countdownSeconds});
}

/// @nodoc
class _$DeclarationCopyWithImpl<$Res, $Val extends Declaration>
    implements $DeclarationCopyWith<$Res> {
  _$DeclarationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? text = null,
    Object? requiresAccept = freezed,
    Object? requiresInput = freezed,
    Object? placeholder = freezed,
    Object? countdownSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      requiresAccept: freezed == requiresAccept
          ? _value.requiresAccept
          : requiresAccept // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresInput: freezed == requiresInput
          ? _value.requiresInput
          : requiresInput // ignore: cast_nullable_to_non_nullable
              as bool?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      countdownSeconds: freezed == countdownSeconds
          ? _value.countdownSeconds
          : countdownSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeclarationImplCopyWith<$Res>
    implements $DeclarationCopyWith<$Res> {
  factory _$$DeclarationImplCopyWith(
          _$DeclarationImpl value, $Res Function(_$DeclarationImpl) then) =
      __$$DeclarationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String text,
      bool? requiresAccept,
      bool? requiresInput,
      String? placeholder,
      int? countdownSeconds});
}

/// @nodoc
class __$$DeclarationImplCopyWithImpl<$Res>
    extends _$DeclarationCopyWithImpl<$Res, _$DeclarationImpl>
    implements _$$DeclarationImplCopyWith<$Res> {
  __$$DeclarationImplCopyWithImpl(
      _$DeclarationImpl _value, $Res Function(_$DeclarationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? text = null,
    Object? requiresAccept = freezed,
    Object? requiresInput = freezed,
    Object? placeholder = freezed,
    Object? countdownSeconds = freezed,
  }) {
    return _then(_$DeclarationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      requiresAccept: freezed == requiresAccept
          ? _value.requiresAccept
          : requiresAccept // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresInput: freezed == requiresInput
          ? _value.requiresInput
          : requiresInput // ignore: cast_nullable_to_non_nullable
              as bool?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      countdownSeconds: freezed == countdownSeconds
          ? _value.countdownSeconds
          : countdownSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeclarationImpl implements _Declaration {
  const _$DeclarationImpl(
      {required this.id,
      required this.type,
      required this.text,
      this.requiresAccept,
      this.requiresInput,
      this.placeholder,
      this.countdownSeconds});

  factory _$DeclarationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeclarationImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// 'declaration', 'answer', 'do'
  @override
  final String text;
  @override
  final bool? requiresAccept;
  @override
  final bool? requiresInput;
  @override
  final String? placeholder;
  @override
  final int? countdownSeconds;

  @override
  String toString() {
    return 'Declaration(id: $id, type: $type, text: $text, requiresAccept: $requiresAccept, requiresInput: $requiresInput, placeholder: $placeholder, countdownSeconds: $countdownSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeclarationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.requiresAccept, requiresAccept) ||
                other.requiresAccept == requiresAccept) &&
            (identical(other.requiresInput, requiresInput) ||
                other.requiresInput == requiresInput) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.countdownSeconds, countdownSeconds) ||
                other.countdownSeconds == countdownSeconds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, text, requiresAccept,
      requiresInput, placeholder, countdownSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeclarationImplCopyWith<_$DeclarationImpl> get copyWith =>
      __$$DeclarationImplCopyWithImpl<_$DeclarationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeclarationImplToJson(
      this,
    );
  }
}

abstract class _Declaration implements Declaration {
  const factory _Declaration(
      {required final String id,
      required final String type,
      required final String text,
      final bool? requiresAccept,
      final bool? requiresInput,
      final String? placeholder,
      final int? countdownSeconds}) = _$DeclarationImpl;

  factory _Declaration.fromJson(Map<String, dynamic> json) =
      _$DeclarationImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override // 'declaration', 'answer', 'do'
  String get text;
  @override
  bool? get requiresAccept;
  @override
  bool? get requiresInput;
  @override
  String? get placeholder;
  @override
  int? get countdownSeconds;
  @override
  @JsonKey(ignore: true)
  _$$DeclarationImplCopyWith<_$DeclarationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeclarationResponse _$DeclarationResponseFromJson(Map<String, dynamic> json) {
  return _DeclarationResponse.fromJson(json);
}

/// @nodoc
mixin _$DeclarationResponse {
  String get declarationId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get userInput => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeclarationResponseCopyWith<DeclarationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeclarationResponseCopyWith<$Res> {
  factory $DeclarationResponseCopyWith(
          DeclarationResponse value, $Res Function(DeclarationResponse) then) =
      _$DeclarationResponseCopyWithImpl<$Res, DeclarationResponse>;
  @useResult
  $Res call(
      {String declarationId,
      String type,
      String text,
      String? userInput,
      DateTime completedAt});
}

/// @nodoc
class _$DeclarationResponseCopyWithImpl<$Res, $Val extends DeclarationResponse>
    implements $DeclarationResponseCopyWith<$Res> {
  _$DeclarationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? declarationId = null,
    Object? type = null,
    Object? text = null,
    Object? userInput = freezed,
    Object? completedAt = null,
  }) {
    return _then(_value.copyWith(
      declarationId: null == declarationId
          ? _value.declarationId
          : declarationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: freezed == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeclarationResponseImplCopyWith<$Res>
    implements $DeclarationResponseCopyWith<$Res> {
  factory _$$DeclarationResponseImplCopyWith(_$DeclarationResponseImpl value,
          $Res Function(_$DeclarationResponseImpl) then) =
      __$$DeclarationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String declarationId,
      String type,
      String text,
      String? userInput,
      DateTime completedAt});
}

/// @nodoc
class __$$DeclarationResponseImplCopyWithImpl<$Res>
    extends _$DeclarationResponseCopyWithImpl<$Res, _$DeclarationResponseImpl>
    implements _$$DeclarationResponseImplCopyWith<$Res> {
  __$$DeclarationResponseImplCopyWithImpl(_$DeclarationResponseImpl _value,
      $Res Function(_$DeclarationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? declarationId = null,
    Object? type = null,
    Object? text = null,
    Object? userInput = freezed,
    Object? completedAt = null,
  }) {
    return _then(_$DeclarationResponseImpl(
      declarationId: null == declarationId
          ? _value.declarationId
          : declarationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: freezed == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeclarationResponseImpl implements _DeclarationResponse {
  const _$DeclarationResponseImpl(
      {required this.declarationId,
      required this.type,
      required this.text,
      this.userInput,
      required this.completedAt});

  factory _$DeclarationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeclarationResponseImplFromJson(json);

  @override
  final String declarationId;
  @override
  final String type;
  @override
  final String text;
  @override
  final String? userInput;
  @override
  final DateTime completedAt;

  @override
  String toString() {
    return 'DeclarationResponse(declarationId: $declarationId, type: $type, text: $text, userInput: $userInput, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeclarationResponseImpl &&
            (identical(other.declarationId, declarationId) ||
                other.declarationId == declarationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.userInput, userInput) ||
                other.userInput == userInput) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, declarationId, type, text, userInput, completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeclarationResponseImplCopyWith<_$DeclarationResponseImpl> get copyWith =>
      __$$DeclarationResponseImplCopyWithImpl<_$DeclarationResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeclarationResponseImplToJson(
      this,
    );
  }
}

abstract class _DeclarationResponse implements DeclarationResponse {
  const factory _DeclarationResponse(
      {required final String declarationId,
      required final String type,
      required final String text,
      final String? userInput,
      required final DateTime completedAt}) = _$DeclarationResponseImpl;

  factory _DeclarationResponse.fromJson(Map<String, dynamic> json) =
      _$DeclarationResponseImpl.fromJson;

  @override
  String get declarationId;
  @override
  String get type;
  @override
  String get text;
  @override
  String? get userInput;
  @override
  DateTime get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$DeclarationResponseImplCopyWith<_$DeclarationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
