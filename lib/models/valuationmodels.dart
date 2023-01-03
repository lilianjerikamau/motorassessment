import 'package:json_annotation/json_annotation.dart';

part 'valuationmodels.g.dart';

@JsonSerializable()
class Valuation {
  Valuation({
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
    this.custname,
    this.customer,
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
  String? custname;
  String? customer;

  factory Valuation.fromJson(Map<String, dynamic> json) => Valuation(
        userid: json["userid"],
        customer: json["customer"],
        id: json["id"],
        custid: json["custid"],
        regno: json['regno'],
        make: json["make"],
        drivenby: json['drivenby'],
        towed: json["towed"],
        cashinlieu: json["cashinlieu"],
        instructionno: json['companyname'],
        owner: json["owner"],
        claimno: json['claimno'],
        custname: json["customer"],
        chassisno: json["chassisno"],
        policyno: json["policyno"],
        location: json['location'],
        model: json["model"],
      );

  Map<String, dynamic> toJson() => {};
}
