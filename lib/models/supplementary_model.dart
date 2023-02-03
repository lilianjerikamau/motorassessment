class SupplementaryModel{
  int? id;
  String? supplementaryjson;

  SupplementaryModel(
      {
        this.id,
        this.supplementaryjson
      });

  SupplementaryModel.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        supplementaryjson = data['supplementaryjson'];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplementaryjson': supplementaryjson,
    };
  }
}