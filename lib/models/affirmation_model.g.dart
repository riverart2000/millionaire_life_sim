// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affirmation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AffirmationModelImpl _$$AffirmationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AffirmationModelImpl(
      id: json['id'] as String,
      fullText: json['fullText'] as String,
      words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
      blankIndices: (json['blankIndices'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      userAnswers: (json['userAnswers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completed: json['completed'] as bool? ?? false,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AffirmationModelImplToJson(
        _$AffirmationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullText': instance.fullText,
      'words': instance.words,
      'blankIndices': instance.blankIndices,
      'userAnswers': instance.userAnswers,
      'completed': instance.completed,
      'attempts': instance.attempts,
    };

_$AffirmationProgressImpl _$$AffirmationProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$AffirmationProgressImpl(
      totalAffirmations: (json['totalAffirmations'] as num?)?.toInt() ?? 0,
      completedAffirmations:
          (json['completedAffirmations'] as num?)?.toInt() ?? 0,
      completedIds: (json['completedIds'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      lastPracticeDate: json['lastPracticeDate'] == null
          ? null
          : DateTime.parse(json['lastPracticeDate'] as String),
    );

Map<String, dynamic> _$$AffirmationProgressImplToJson(
        _$AffirmationProgressImpl instance) =>
    <String, dynamic>{
      'totalAffirmations': instance.totalAffirmations,
      'completedAffirmations': instance.completedAffirmations,
      'completedIds': instance.completedIds,
      'lastPracticeDate': instance.lastPracticeDate?.toIso8601String(),
    };
