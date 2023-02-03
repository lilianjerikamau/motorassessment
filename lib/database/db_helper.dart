import 'package:motorassesmentapp/models/assessmentmodels.dart';
import 'package:motorassesmentapp/models/inspectionmodels.dart';
import 'package:motorassesmentapp/models/supplementary_model.dart';
import 'package:motorassesmentapp/models/supplementarymodels.dart';
import 'package:motorassesmentapp/models/valuation_model.dart';
import 'package:motorassesmentapp/models/valuationmodels.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import '../models/assessment_model.dart';
import '../models/reinspection_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'assessments.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // creating database table
  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE assessment (id INTEGER PRIMARY KEY, assessmentjson TEXT)');
    await db.execute(
        'CREATE TABLE valuation (id INTEGER PRIMARY KEY, valuationjson TEXT)');
    await db.execute(
        'CREATE TABLE reinspection (id INTEGER PRIMARY KEY, reinspectionjson TEXT)');
    await db.execute(
        'CREATE TABLE supplementary (id INTEGER PRIMARY KEY, supplementaryjson TEXT)');
  }

// inserting data into the table
  Future<AssessmentModel> insert(AssessmentModel assesssment) async {
    var dbClient = await database;
    await dbClient!.insert('assessment', assesssment.toMap());
    return assesssment;
  }

// getting all the items in the list from the database
  Future<List<AssessmentModel>> getAssesssmentList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('assessment');
    return queryResult.map((result) => AssessmentModel.fromMap(result)).toList();
  }

// deleting an item from the Assesssment screen
  Future<int> deleteAssesssmentItem(int id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('assessment', where: 'id = ?', whereArgs: [id]);
  }
  Future<ValuationModel> insertValuation(ValuationModel valuation) async {
    var dbClient = await database;
    await dbClient!.insert('valuation', valuation.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return valuation;
  }

// getting all the items in the list from the database
  Future<List<ValuationModel>> getValuationList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('valuation');
    return queryResult.map((result) => ValuationModel.fromMap(result)).toList();
  }

// deleting an item from the Assesssment screen
  Future<int> deleteValuationItem(int id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('valuation', where: 'id = ?', whereArgs: [id]);
  }
  Future<ReinspectionModel> insertReinspection(ReinspectionModel reinspection) async {
    var dbClient = await database;
    await dbClient!.insert('reinspection', reinspection.toMap());
    return reinspection;
  }

// getting all the items in the list from the database
  Future<List<ReinspectionModel>> getReinsppectionList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('reinspection');
    return queryResult.map((result) => ReinspectionModel.fromMap(result)).toList();
  }

// deleting an item from the Assesssment screen
  Future<int> deleteReinspectionItem(int id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('reinspection', where: 'id = ?', whereArgs: [id]);
  }
  Future<SupplementaryModel> insertSupplementary(SupplementaryModel supplementary) async {
    var dbClient = await database;
    await dbClient!.insert('supplementary', supplementary.toMap());
    return supplementary;
  }

// getting all the items in the list from the database
  Future<List<SupplementaryModel>> getSupplementaryList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('supplementary');
    return queryResult.map((result) => SupplementaryModel.fromMap(result)).toList();
  }

// deleting an item from the Assesssment screen
  Future<int> deleteSupplementaryItem(int id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('supplementary', where: 'id = ?', whereArgs: [id]);
  }
}
