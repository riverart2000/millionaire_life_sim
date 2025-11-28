import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
class Course with _$Course {
  const factory Course({
    required String id,
    required String title,
    required String description,
    required String category,
    required double cost,
    @Default(0.1) double mindsetIncrease,
    required String duration,
    required String icon,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
