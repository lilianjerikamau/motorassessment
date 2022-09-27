// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplementarymodels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplementary _$SupplementaryFromJson(Map<String, dynamic> json) =>
    Supplementary(
      userid: json['userid'] as int?,
      regno: json['regno'] as String?,
      custid: json['custid'] as int?,
      revised: json['revised'] as bool?,
      cashinlieu: json['cashinlieu'] as bool?,
      instructionno: json['instructionno'] as int?,
      drivenby: json['drivenby'] as String?,
      towed: json['towed'] as bool?,
      make: json['make'] as String?,
      model: json['model'] as String?,
      year: json['year'] as String?,
      mileage: json['mileage'] as String?,
      color: json['color'] as String?,
      chasisno: json['chasisno'] as String?,
      pav: json['pav'] as String?,
      salvage: json['salvage'] as String?,
      RHF: json['RHF'] as String?,
      LHR: json['LHR'] as String?,
      RHR: json['RHR'] as String?,
      LHF: json['LHF'] as String?,
      Spare: json['Spare'] as String?,
      photolist: json['photolist'] as String?,
      owner: json['owner'] as String?,
      claimno: json['claimno'] as String?,
      chassisno: json['chassisno'] as String?,
      policyno: json['policyno'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$SupplementaryToJson(Supplementary instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'make': instance.make,
      'drivenby': instance.drivenby,
      'towed': instance.towed,
      'cashinlieu': instance.cashinlieu,
      'instructionno': instance.instructionno,
      'custid': instance.custid,
      'regno': instance.regno,
      'model': instance.model,
      'year': instance.year,
      'revised': instance.revised,
      'mileage': instance.mileage,
      'color': instance.color,
      'chasisno': instance.chasisno,
      'pav': instance.pav,
      'salvage': instance.salvage,
      'RHF': instance.RHF,
      'LHR': instance.LHR,
      'RHR': instance.RHR,
      'LHF': instance.LHF,
      'Spare': instance.Spare,
      'photolist': instance.photolist,
      'owner': instance.owner,
      'claimno': instance.claimno,
      'chassisno': instance.chassisno,
      'policyno': instance.policyno,
      'location': instance.location,
    };
