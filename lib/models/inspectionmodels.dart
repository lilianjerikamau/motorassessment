import 'package:json_annotation/json_annotation.dart';

part 'inspectionmodels.g.dart';

@JsonSerializable()
class Inspection {
  Inspection({
    this.assessmentno,
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
    this.customer,
  });
  Inspection.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        userid = data['userid'],
        revised = data['revised'],
        instructionno = data['instructionno'],
        assessmentno = data['assessmentno'],
        remarks = data['remarks'],
        engineno= data['engineno'],
        chassisno = data['chassisno'],
        make = data['make'],
        regno = data['regno'],
        model = data['model'],
        year = data['year'],
        brakes = data['brakes'],
        mileage = data['mileage'],
        color = data['color'],
        pav = data['pav'],
        salvage = data['salvage'],
        paintwork = data['paintwork'],
        RHF = data['RHF'],
        LHR = data['LHR'],
        RHR = data['RHR'],
        LHF = data['LHF'],
        photolist = data['photolist']
  ;
  Map<String, dynamic> toMap() {
    return {
      'id' :id,
      'userid':userid,
      'revised' :revised,
      'instructionno':instructionno,
      'assessmentno':assessmentno,
      'remarks' :remarks,
      'engineno':engineno,
      'chassisno' :chassisno,
      'make':make,
      'regno' :regno,
      'model' :model,
      'year' :year,
      'brakes' :brakes,
      'mileage':mileage,
      'color' :color,
      'pav':pav,
      'salvage':salvage,
      'paintwork' :paintwork,
      'RHF' :RHF,
      'LHR':LHR,
      'RHR' :RHR,
      'LHF':LHF,
      'photolist' :photolist
    };
  }
  int? id;
  int? userid;
  String? make;
  String? drivenby;
  String? customer;
  String ?remarks;
  bool? towed;
  bool? cashinlieu;
  int? instructionno;
  int? assessmentno;
  int? custid;
  String? brakes;
  String? engineno;
  String? paintwork;
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
        custname: json["custname"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {};
}
