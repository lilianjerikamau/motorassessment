import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:motorassesmentapp/models/assessment_model.dart';
import 'package:motorassesmentapp/models/assessmentmodels.dart';
import 'package:motorassesmentapp/models/reinspection_model.dart';
import 'package:motorassesmentapp/models/supplementary_model.dart';
import 'package:motorassesmentapp/models/supplementarymodels.dart';

import '../database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/valuation_model.dart';


class AsessmentProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;



  List<AssessmentModel> assessment = [];
  List<ValuationModel> valuation = [];
  List<SupplementaryModel> supplementary = [];
  List<ReinspectionModel> reinspection = [];
  Future<List<AssessmentModel>> getData() async {
    assessment = (await dbHelper.getAssesssmentList());
   // import 'dart:convert';
    notifyListeners();
    print('assessments are');
    print(assessment);
    return assessment;
  }

  void removeItem(int id) {
    final index = assessment.indexWhere((element) => element.id == id);
    assessment.removeAt(index);

    notifyListeners();
  }
  Future<List<ValuationModel>> getValData() async {
    valuation = (await dbHelper.getValuationList());
    notifyListeners();
    print('valuations are');
    print(assessment);
    return valuation;
  }

  void removeValItem(int id) {
    final index = valuation.indexWhere((element) => element.id == id);
    valuation.removeAt(index);

    notifyListeners();
  }
  Future<List<SupplementaryModel>> getSupData() async {
    supplementary = (await dbHelper.getSupplementaryList());
    // import 'dart:convert';
    notifyListeners();
    return supplementary;
  }

  void removeSupItem(int id) {
    final index = supplementary.indexWhere((element) => element.id == id);
    supplementary.removeAt(index);
    notifyListeners();
  }
  Future<List<ReinspectionModel>> getReinspData() async {
    reinspection = (await dbHelper.getReinsppectionList());
    notifyListeners();
    return reinspection;
  }

  void removeReinspItem(int id) {
    final index = reinspection.indexWhere((element) => element.id == id);
    reinspection.removeAt(index);
    notifyListeners();
  }
}