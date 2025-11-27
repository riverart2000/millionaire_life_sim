import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'affirmation_model.freezed.dart';
part 'affirmation_model.g.dart';

@freezed
class AffirmationModel with _$AffirmationModel {
  const factory AffirmationModel({
    required String id,
    required String fullText,
    required List<String> words,
    required List<int> blankIndices,
    @Default([]) List<String> userAnswers,
    @Default(false) bool completed,
    @Default(0) int attempts,
  }) = _AffirmationModel;

  factory AffirmationModel.fromJson(Map<String, dynamic> json) =>
      _$AffirmationModelFromJson(json);
}

@freezed
class AffirmationProgress with _$AffirmationProgress {
  const factory AffirmationProgress({
    @Default(0) int totalAffirmations,
    @Default(0) int completedAffirmations,
    @Default({}) Map<String, bool> completedIds,
    DateTime? lastPracticeDate,
    @Default(0) int dailyStreak,
    DateTime? lastQuestDate,
    @Default(false) bool todayQuestCompleted,
  }) = _AffirmationProgress;

  factory AffirmationProgress.fromJson(Map<String, dynamic> json) =>
      _$AffirmationProgressFromJson(json);
}
