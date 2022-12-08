import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'assessmentmodels.g.dart';

@JsonSerializable()
class Assesssment {
  Assesssment(
      {this.id,
      this.brakes,
      this.damegesobserved,
      this.paintwork,
      this.steering,
      this.driven,
      this.userid,
      this.custname,
      this.regno,
      this.custid,
      this.revised,
      this.cashinlieu,
      this.instructionno,
      this.drivenby,
      this.towed,
      this.make,
      this.model,
      this.year,
      this.mileage,
      this.color,
      this.chasisno,
      this.pav,
      this.salvage,
      this.RHF,
      this.LHR,
      this.RHR,
      this.LHF,
      this.Spare,
      this.photolist,
      this.owner,
      this.claimno,
      this.chassisno,
      this.policyno,
      this.location,
      this.date,
      this.engineno});

  int? userid;
  int? id;
  String? damegesobserved;
  String? paintwork;
  String? steering;
  String? brakes;
  bool? driven;
  String? make;
  String? engineno;
  String? drivenby;
  bool? towed;
  bool? cashinlieu;
  int? instructionno;
  int? custid;
  String? regno;
  String? model;
  String? year;
  String? custname;
  bool? revised;
  String? mileage;
  String? color;
  String? chasisno;
  String? pav;
  String? salvage;
  String? RHF;
  String? LHR;
  String? RHR;
  String? LHF;
  String? Spare;
  List<Map<String, dynamic>>? photolist;
  String? owner;
  String? claimno;
  String? chassisno;
  String? policyno;
  String? location;
  String? date;

  factory Assesssment.fromJson(Map<String, dynamic> json) => Assesssment(
        userid: json["userid"],
        id: json["id"],
        custid: json["custid"],
        date: json["date"],
        regno: json['regno'],
        make: json["make"],
        custname: json["customer"],
        drivenby: json['drivenby'],
        towed: json["towed"],
        cashinlieu: json["cashinlieu"],
        instructionno: json['companyname'],
        owner: json["owner"],
        claimno: json['claimno'],
        chassisno: json["chassisno"],
        policyno: json["policyno"],
        location: json['location'],
        model: json["model"],
        damegesobserved: json["damegesobserved"],
        paintwork: json["paintwork"],
        steering: json["steering"],
        brakes: json["brakes"],
        driven: json["driven"],
      );
  static Map<String, dynamic> toJson(Assesssment assesssment) => {
        'driven': assesssment.driven,
        'id': assesssment.id,
        'custid': assesssment.custid,
        'brakes': assesssment.brakes,
        'steering': assesssment.steering,
        'paintwork': assesssment.paintwork,
        'damegesobserved': assesssment.damegesobserved,
        'userid': assesssment.userid,
        'date': assesssment.date,
        'regno': assesssment.regno,
        'make': assesssment.make,
        'customer': assesssment.custname,
        'drivenby': assesssment.drivenby,
        'towed': assesssment.towed,
        'cashinlieu': assesssment.cashinlieu,
        'companyname': assesssment.instructionno,
        'owner': assesssment.owner,
        'claimno': assesssment.claimno,
        'chassisno': assesssment.chassisno,
        'policyno': assesssment.policyno,
        'location': assesssment.location,
        'model': assesssment.model,
      };

  @override
  String toString() {
    return '"Assesssment" : { "driven":$driven, "brakes": $brakes, "steering": $steering,"paintwork":$paintwork,"damegesobserved":$damegesobserved,"userid":$userid,"date":$date,"regno"$regno,"make"$make,"customer"$custname,"drivenby"$drivenby,"towed"$towed,"cashinlieu":$cashinlieu,"companyname":$instructionno,"owner":$owner,"claimno":$claimno,"chassisno":$chassisno,"policyno":$policyno,"location":$location,"model":$model}';
  }
}
