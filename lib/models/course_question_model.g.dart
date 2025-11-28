// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseQuestionImpl _$$CourseQuestionImplFromJson(Map<String, dynamic> json) =>
    _$CourseQuestionImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswer: (json['correctAnswer'] as num).toInt(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$$CourseQuestionImplToJson(
        _$CourseQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
      'explanation': instance.explanation,
    };

_$CourseQuizImpl _$$CourseQuizImplFromJson(Map<String, dynamic> json) =>
    _$CourseQuizImpl(
      courseId: json['courseId'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => CourseQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CourseQuizImplToJson(_$CourseQuizImpl instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'questions': instance.questions,
    };
