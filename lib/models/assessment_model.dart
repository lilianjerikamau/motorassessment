class AssessmentModel{
  int? id;
  String? assessmentjson;

  AssessmentModel(
      {
    this.id,
        this.assessmentjson
      });

  AssessmentModel.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        assessmentjson = data['assessmentjson'];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assessmentjson': assessmentjson,
    };
  }
}