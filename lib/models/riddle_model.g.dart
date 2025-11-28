// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riddle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RiddleImpl _$$RiddleImplFromJson(Map<String, dynamic> json) => _$RiddleImpl(
      id: json['id'] as String,
      difficulty: json['difficulty'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      riddle: json['riddle'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctOptionIndex: (json['correct_option_index'] as num).toInt(),
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$$RiddleImplToJson(_$RiddleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'difficulty': instance.difficulty,
      'tags': instance.tags,
      'riddle': instance.riddle,
      'options': instance.options,
      'correct_option_index': instance.correctOptionIndex,
      'answer': instance.answer,
      'explanation': instance.explanation,
    };

_$RiddleCategoryImpl _$$RiddleCategoryImplFromJson(Map<String, dynamic> json) =>
    _$RiddleCategoryImpl(
      category: json['category'] as String,
      description: json['description'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Riddle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RiddleCategoryImplToJson(
        _$RiddleCategoryImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'description': instance.description,
      'items': instance.items,
    };
