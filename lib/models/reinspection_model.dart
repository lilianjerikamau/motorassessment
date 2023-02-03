class ReinspectionModel{
  int? id;
  String? reinspectionjson;

  ReinspectionModel(
      {
        this.id,
        this.reinspectionjson
      });

  ReinspectionModel.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        reinspectionjson = data['reinspectionjson'];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reinspectionjson': reinspectionjson,
    };
  }
}