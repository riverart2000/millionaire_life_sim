// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CourseQuestion _$CourseQuestionFromJson(Map<String, dynamic> json) {
  return _CourseQuestion.fromJson(json);
}

/// @nodoc
mixin _$CourseQuestion {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  int get correctAnswer => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseQuestionCopyWith<CourseQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseQuestionCopyWith<$Res> {
  factory $CourseQuestionCopyWith(
          CourseQuestion value, $Res Function(CourseQuestion) then) =
      _$CourseQuestionCopyWithImpl<$Res, CourseQuestion>;
  @useResult
  $Res call(
      {String id,
      String text,
      List<String> options,
      int correctAnswer,
      String explanation});
}

/// @nodoc
class _$CourseQuestionCopyWithImpl<$Res, $Val extends CourseQuestion>
    implements $CourseQuestionCopyWith<$Res> {
  _$CourseQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as int,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseQuestionImplCopyWith<$Res>
    implements $CourseQuestionCopyWith<$Res> {
  factory _$$CourseQuestionImplCopyWith(_$CourseQuestionImpl value,
          $Res Function(_$CourseQuestionImpl) then) =
      __$$CourseQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      List<String> options,
      int correctAnswer,
      String explanation});
}

/// @nodoc
class __$$CourseQuestionImplCopyWithImpl<$Res>
    extends _$CourseQuestionCopyWithImpl<$Res, _$CourseQuestionImpl>
    implements _$$CourseQuestionImplCopyWith<$Res> {
  __$$CourseQuestionImplCopyWithImpl(
      _$CourseQuestionImpl _value, $Res Function(_$CourseQuestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = null,
  }) {
    return _then(_$CourseQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as int,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseQuestionImpl implements _CourseQuestion {
  const _$CourseQuestionImpl(
      {required this.id,
      required this.text,
      required final List<String> options,
      required this.correctAnswer,
      required this.explanation})
      : _options = options;

  factory _$CourseQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final int correctAnswer;
  @override
  final String explanation;

  @override
  String toString() {
    return 'CourseQuestion(id: $id, text: $text, options: $options, correctAnswer: $correctAnswer, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      const DeepCollectionEquality().hash(_options),
      correctAnswer,
      explanation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseQuestionImplCopyWith<_$CourseQuestionImpl> get copyWith =>
      __$$CourseQuestionImplCopyWithImpl<_$CourseQuestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseQuestionImplToJson(
      this,
    );
  }
}

abstract class _CourseQuestion implements CourseQuestion {
  const factory _CourseQuestion(
      {required final String id,
      required final String text,
      required final List<String> options,
      required final int correctAnswer,
      required final String explanation}) = _$CourseQuestionImpl;

  factory _CourseQuestion.fromJson(Map<String, dynamic> json) =
      _$CourseQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  List<String> get options;
  @override
  int get correctAnswer;
  @override
  String get explanation;
  @override
  @JsonKey(ignore: true)
  _$$CourseQuestionImplCopyWith<_$CourseQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseQuiz _$CourseQuizFromJson(Map<String, dynamic> json) {
  return _CourseQuiz.fromJson(json);
}

/// @nodoc
mixin _$CourseQuiz {
  String get courseId => throw _privateConstructorUsedError;
  List<CourseQuestion> get questions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseQuizCopyWith<CourseQuiz> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseQuizCopyWith<$Res> {
  factory $CourseQuizCopyWith(
          CourseQuiz value, $Res Function(CourseQuiz) then) =
      _$CourseQuizCopyWithImpl<$Res, CourseQuiz>;
  @useResult
  $Res call({String courseId, List<CourseQuestion> questions});
}

/// @nodoc
class _$CourseQuizCopyWithImpl<$Res, $Val extends CourseQuiz>
    implements $CourseQuizCopyWith<$Res> {
  _$CourseQuizCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? questions = null,
  }) {
    return _then(_value.copyWith(
      courseId: null == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<CourseQuestion>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseQuizImplCopyWith<$Res>
    implements $CourseQuizCopyWith<$Res> {
  factory _$$CourseQuizImplCopyWith(
          _$CourseQuizImpl value, $Res Function(_$CourseQuizImpl) then) =
      __$$CourseQuizImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String courseId, List<CourseQuestion> questions});
}

/// @nodoc
class __$$CourseQuizImplCopyWithImpl<$Res>
    extends _$CourseQuizCopyWithImpl<$Res, _$CourseQuizImpl>
    implements _$$CourseQuizImplCopyWith<$Res> {
  __$$CourseQuizImplCopyWithImpl(
      _$CourseQuizImpl _value, $Res Function(_$CourseQuizImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? questions = null,
  }) {
    return _then(_$CourseQuizImpl(
      courseId: null == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<CourseQuestion>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseQuizImpl implements _CourseQuiz {
  const _$CourseQuizImpl(
      {required this.courseId, required final List<CourseQuestion> questions})
      : _questions = questions;

  factory _$CourseQuizImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseQuizImplFromJson(json);

  @override
  final String courseId;
  final List<CourseQuestion> _questions;
  @override
  List<CourseQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'CourseQuiz(courseId: $courseId, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseQuizImpl &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, courseId, const DeepCollectionEquality().hash(_questions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseQuizImplCopyWith<_$CourseQuizImpl> get copyWith =>
      __$$CourseQuizImplCopyWithImpl<_$CourseQuizImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseQuizImplToJson(
      this,
    );
  }
}

abstract class _CourseQuiz implements CourseQuiz {
  const factory _CourseQuiz(
      {required final String courseId,
      required final List<CourseQuestion> questions}) = _$CourseQuizImpl;

  factory _CourseQuiz.fromJson(Map<String, dynamic> json) =
      _$CourseQuizImpl.fromJson;

  @override
  String get courseId;
  @override
  List<CourseQuestion> get questions;
  @override
  @JsonKey(ignore: true)
  _$$CourseQuizImplCopyWith<_$CourseQuizImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
