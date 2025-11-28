import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_question_model.freezed.dart';
part 'course_question_model.g.dart';

@freezed
class CourseQuestion with _$CourseQuestion {
  const factory CourseQuestion({
    required String id,
    required String text,
    required List<String> options,
    required int correctAnswer,
    required String explanation,
  }) = _CourseQuestion;

  factory CourseQuestion.fromJson(Map<String, dynamic> json) =>
      _$CourseQuestionFromJson(json);
}

@freezed
class CourseQuiz with _$CourseQuiz {
  const factory CourseQuiz({
    required String courseId,
    required List<CourseQuestion> questions,
  }) = _CourseQuiz;

  factory CourseQuiz.fromJson(Map<String, dynamic> json) =>
      _$CourseQuizFromJson(json);
}
