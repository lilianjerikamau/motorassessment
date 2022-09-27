import 'package:json_annotation/json_annotation.dart';

part 'instructionmodels.g.dart';

@JsonSerializable()
class Instruction {
  String? regno;
  String? owner;
  String? claimno;
  String? chassisno;
  String? policyno;
  String? location;
  String? model;
  String? make;

  Instruction(
      {this.regno,
      this.owner,
      this.claimno,
      this.chassisno,
      this.policyno,
      this.location,
      this.model,
      this.make});
  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        regno: json["regno"],
        owner: json["owner"],
        claimno: json['claimno'],
        chassisno: json["chassisno"],
        policyno: json["policyno"],
        location: json['location'],
        model: json["model"],
        make: json["make"],
      );

  Map<String, dynamic> toJson() => {
        "regno": regno,
        "owner": owner,
        "claimno": claimno,
        "chassisno": chassisno,
        "policyno": policyno,
        'model': model,
        "location": location,
        "make": make,
      };
}
