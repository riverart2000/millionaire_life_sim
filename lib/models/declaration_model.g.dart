// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'declaration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeclarationImpl _$$DeclarationImplFromJson(Map<String, dynamic> json) =>
    _$DeclarationImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      text: json['text'] as String,
      requiresAccept: json['requiresAccept'] as bool?,
      requiresInput: json['requiresInput'] as bool?,
      placeholder: json['placeholder'] as String?,
      countdownSeconds: (json['countdownSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DeclarationImplToJson(_$DeclarationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'text': instance.text,
      'requiresAccept': instance.requiresAccept,
      'requiresInput': instance.requiresInput,
      'placeholder': instance.placeholder,
      'countdownSeconds': instance.countdownSeconds,
    };

_$DeclarationResponseImpl _$$DeclarationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DeclarationResponseImpl(
      declarationId: json['declarationId'] as String,
      type: json['type'] as String,
      text: json['text'] as String,
      userInput: json['userInput'] as String?,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$DeclarationResponseImplToJson(
        _$DeclarationResponseImpl instance) =>
    <String, dynamic>{
      'declarationId': instance.declarationId,
      'type': instance.type,
      'text': instance.text,
      'userInput': instance.userInput,
      'completedAt': instance.completedAt.toIso8601String(),
    };
