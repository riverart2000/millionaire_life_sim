import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/courses_service.dart';

final coursesServiceProvider = Provider<CoursesService>((ref) {
  return CoursesService();
});

final coursesLoadProvider = FutureProvider<void>((ref) async {
  final service = ref.read(coursesServiceProvider);
  await service.loadCourses();
});

final allCoursesProvider = Provider<List<Course>>((ref) {
  ref.watch(coursesLoadProvider);
  final service = ref.read(coursesServiceProvider);
  return service.getAllCourses();
});

final availableCoursesProvider = Provider<List<Course>>((ref) {
  final allCourses = ref.watch(allCoursesProvider);
  // We'll need to get purchased courses from user profile
  // For now, return all courses
  return allCourses;
});

final categoriesProvider = Provider<List<String>>((ref) {
  final service = ref.read(coursesServiceProvider);
  return service.getCategories();
});
