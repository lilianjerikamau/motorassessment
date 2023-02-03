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
        this.type,
      this.driven,
      this.userid,
      this.custname,
      this.customer,
      this.regno,
      this.custid,
      this.revised,
      this.cashinlieu,
      this.instructionno,
      this.drivenby,
      this.towed,
        this.remarks,
        this.yardname,
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

  Assesssment.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        userid = data['userid'],
        paintwork = data['revised'],
        steering = data['cashinlieu'],
        brakes = data['instructionno'],
        driven = data['driven'],
        towed = data['towed'],
        remarks = data['remarks'],
        make = data['make'],
        yardname = data['yardname'],
        regno = data['regno'],
        model = data['model'],
        type = data['type'],
        year = data['year'],
        mileage = data['mileage'],
        color = data['color'],
        pav = data['pav'],
        salvage = data['salvage'],
        RHF = data['RHF'],
        LHR = data['LHR'],
        RHR = data['RHR'],
        LHF = data['LHF'],
        Spare = data['Spare'],
        damegesobserved = data['damagesobserved'],
        photolist = data['photolist'];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid,
      'paintwork': paintwork,
      'steering': steering,
      'brakes': brakes,
      'driven': driven,
      'remarks': remarks,
      'make' :make,
      'yardname' :yardname,
      'regno' :regno,
      'model':model,
      'type':type,
      'year':year,
      'mileage' :mileage,
      'color' :color,
      'pav' :pav,
      'salvage' :salvage,
      'RHF':RHF,
      'LHR' :LHR,
      'RHR' :RHR,
      'LHF':LHF,
      'Spare':Spare,
      'damegesobserved':damegesobserved,
      'photolist':photolist
    };
  }

  int? userid;
  int? id;
  String? damegesobserved;
  String? paintwork;
  String? steering;
  String? brakes;
  String? customer;
  String? remarks;
  String? yardname;
  String? type;


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
 String? photolist;
  String? owner;
  String? claimno;
  String? chassisno;
  String? policyno;
  String? location;
  String? date;

  factory Assesssment.fromJson(Map<String, dynamic> json) => Assesssment(
        userid: json["userid"],
        customer: json["customer"],
        id: json["id"],
        custid: json["custid"],
        date: json["date"],
        regno: json['regno'],
        make: json["make"],
        custname: json["custname"],
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
        'customer': assesssment.customer,
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
