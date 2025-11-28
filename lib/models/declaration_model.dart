import 'package:freezed_annotation/freezed_annotation.dart';

part 'declaration_model.freezed.dart';
part 'declaration_model.g.dart';

/// Represents a single declaration/answer/do item
@freezed
class Declaration with _$Declaration {
  const factory Declaration({
    required String id,
    required String type, // 'declaration', 'answer', 'do'
    required String text,
    bool? requiresAccept,
    bool? requiresInput,
    String? placeholder,
    int? countdownSeconds,
  }) = _Declaration;

  factory Declaration.fromJson(Map<String, dynamic> json) =>
      _$DeclarationFromJson(json);
}

/// Tracks user's responses to declarations
@freezed
class DeclarationResponse with _$DeclarationResponse {
  const factory DeclarationResponse({
    required String declarationId,
    required String type,
    required String text,
    String? userInput,
    required DateTime completedAt,
  }) = _DeclarationResponse;

  factory DeclarationResponse.fromJson(Map<String, dynamic> json) =>
      _$DeclarationResponseFromJson(json);
}
