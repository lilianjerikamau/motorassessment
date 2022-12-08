import 'package:json_annotation/json_annotation.dart';

part 'inspectionmodels.g.dart';

@JsonSerializable()
class Inspection {
  Inspection({
    this.id,
    this.userid,
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
    this.custname,
  });
  int? id;
  int? userid;
  String? make;
  String? drivenby;
  bool? towed;
  bool? cashinlieu;
  int? instructionno;
  int? custid;
  String? regno;
  String? model;
  String? year;
  bool? revised;
  String? mileage;
  String? color;

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
  String? custname;

  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
        id: json["id"],
        userid: json["userid"],
        regno: json['regno'],
        custid: json['custid'],
        make: json["make"],
        policyno: json["policyno"],
        chassisno: json["chassisno"],
        drivenby: json['drivenby'],
        towed: json["towed"],
        cashinlieu: json["cashinlieu"],
        instructionno: json['companyname'],
        owner: json["owner"],
        claimno: json['claimno'],
        location: json['location'],
        model: json["model"],
        custname: json["customer"],
      );

  Map<String, dynamic> toJson() => {};
}
