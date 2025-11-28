// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      cost: (json['cost'] as num).toDouble(),
      mindsetIncrease: (json['mindsetIncrease'] as num?)?.toDouble() ?? 0.1,
      duration: json['duration'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$CourseImplToJson(_$CourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'cost': instance.cost,
      'mindsetIncrease': instance.mindsetIncrease,
      'duration': instance.duration,
      'icon': instance.icon,
    };
