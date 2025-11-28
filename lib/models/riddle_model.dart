import 'package:freezed_annotation/freezed_annotation.dart';

part 'riddle_model.freezed.dart';
part 'riddle_model.g.dart';

@freezed
class Riddle with _$Riddle {
  const factory Riddle({
    required String id,
    required String difficulty,
    required List<String> tags,
    required String riddle,
    required List<String> options,
    @JsonKey(name: 'correct_option_index') required int correctOptionIndex,
    required String answer,
    required String explanation,
  }) = _Riddle;

  factory Riddle.fromJson(Map<String, dynamic> json) => _$RiddleFromJson(json);
}

@freezed
class RiddleCategory with _$RiddleCategory {
  const factory RiddleCategory({
    required String category,
    required String description,
    required List<Riddle> items,
  }) = _RiddleCategory;

  factory RiddleCategory.fromJson(Map<String, dynamic> json) =>
      _$RiddleCategoryFromJson(json);
}
