// import 'package:json_annotation/json_annotation.dart';



// @JsonSerializable()
class Dropdownval {
  Dropdownval({
    this.id,
    this.name,


  });

  int? id;
  String? name;



  factory Dropdownval.fromJson(Map<String, dynamic> json) => Dropdownval(
    id: json["id"],
    name: json["name"],



  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,


  };
}



