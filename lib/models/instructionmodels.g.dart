// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructionmodels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instruction _$InstructionFromJson(Map<String, dynamic> json) => Instruction(
      regno: json['regno'] as String?,
      owner: json['owner'] as String?,
      claimno: json['claimno'] as String?,
      chassisno: json['chassisno'] as String?,
      policyno: json['policyno'] as String?,
      location: json['location'] as String?,
      model: json['model'] as String?,
      make: json['make'] as String?,
    );

Map<String, dynamic> _$InstructionToJson(Instruction instance) =>
    <String, dynamic>{
      'regno': instance.regno,
      'owner': instance.owner,
      'claimno': instance.claimno,
      'chassisno': instance.chassisno,
      'policyno': instance.policyno,
      'location': instance.location,
      'model': instance.model,
      'make': instance.make,
    };
