class ValuationModel{
  int? id;
  String? valuationjson;

  ValuationModel(
      {
        this.id,
        this.valuationjson
      });

  ValuationModel.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        valuationjson = data['valuationjson'];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valuationjson': valuationjson,
    };
  }
}