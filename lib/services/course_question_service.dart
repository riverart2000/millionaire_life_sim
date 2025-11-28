import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/course_question_model.dart';

class CourseQuestionService {
  final Map<String, CourseQuiz> _quizCache = {};

  /// Load questions for a specific course
  Future<CourseQuiz?> loadCourseQuestions(String courseId) async {
    // Check cache first
    if (_quizCache.containsKey(courseId)) {
      return _quizCache[courseId];
    }

    try {
      final String response = await rootBundle.loadString(
        'assets/data/course_questions/${courseId}_questions.json',
      );
      final Map<String, dynamic> data = json.decode(response);
      final quiz = CourseQuiz.fromJson(data);
      
      // Cache it
      _quizCache[courseId] = quiz;
      
      debugPrint('✅ Loaded ${quiz.questions.length} questions for course $courseId');
      return quiz;
    } catch (e) {
      debugPrint('⚠️ No questions found for course $courseId: $e');
      return null;
    }
  }

  /// Clear cache (useful for testing)
  void clearCache() {
    _quizCache.clear();
  }
}
