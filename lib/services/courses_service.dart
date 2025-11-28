import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course_model.dart';

class CoursesService {
  List<Course> _courses = [];

  Future<void> loadCourses() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _courses = jsonList.map((json) => Course.fromJson(json)).toList();
      print('✅ Loaded ${_courses.length} courses from JSON');
    } catch (e) {
      print('❌ Error loading courses: $e');
      _courses = [];
    }
  }

  List<Course> getAllCourses() {
    return List.unmodifiable(_courses);
  }

  List<Course> getAvailableCourses(List<String> purchasedCourseIds) {
    return _courses.where((course) => !purchasedCourseIds.contains(course.id)).toList();
  }

  List<Course> getPurchasedCourses(List<String> purchasedCourseIds) {
    return _courses.where((course) => purchasedCourseIds.contains(course.id)).toList();
  }

  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> getCategories() {
    final categories = _courses.map((course) => course.category).toSet().toList();
    categories.sort();
    return categories;
  }

  List<Course> getCoursesByCategory(String category) {
    return _courses.where((course) => course.category == category).toList();
  }
}
