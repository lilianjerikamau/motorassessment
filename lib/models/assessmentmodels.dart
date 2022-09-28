import 'package:json_annotation/json_annotation.dart';

part 'assessmentmodels.g.dart';

@JsonSerializable()
class Assesssment {
  Assesssment({
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
  });

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

  factory Assesssment.fromJson(Map<String, dynamic> json) => Assesssment(
        userid: json["userid"],
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
      );

  Map<String, dynamic> toJson() => {};
}
