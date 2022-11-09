// import 'dart:math';
// import 'package:motorassesmentapp/models/usermodels.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DBStore {
//   DBStore._();

//   static Database _sqDatabase;
//   static final db = DBStore._();

//   Future<Database> get database async {
//     // If database exists, return database
//     if (_sqDatabase != null) {
//       return _sqDatabase;
//     }

//     // If database don't exists, create one
//     _sqDatabase = await initNewDB();

//     return _sqDatabase;
//   }

//   Future initNewDB() async {
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, 'customer_list_sqlite.db');

//     return await openDatabase(path, version: 1, onOpen: (db) {},
//         onCreate: (Database db, int version) async {
//       // Table for App Labels
//       await db.execute(
//         'CREATE TABLE Customer(id INTEGER PRIMARY KEY,author TEXT,quote TEXT, quoteId TEXT)',
//       );
//       await db.execute(
//         'CREATE TABLE ApiCacheLog(id INTEGER PRIMARY KEY,name TEXT,lastUpdated TEXT)',
//       );
//     });
//   }

//   Future updateCacheLog(CacheLog cacheLog) async {
//     final db = await database;
//     final queryResult = await db.insert('ApiCacheLog', cacheLog.toMap());

//     return queryResult;
//   }

//   // Get Cache Log
//   Future getCacheLogs() async {
//     final db = await database;
//     final logs = await db.query('ApiCacheLog');

//     return logs.isNotEmpty
//         ? List.generate(
//             logs.length,
//             (i) => CacheLog(
//               logs[i]['id'],
//               logs[i]['name'],
//               logs[i]['lastUpdated'],
//             ),
//           )
//         : [];
//   }

//   Future inserCustomer(List quotesList) async {
//     final db = await database;
//     final batch = db.batch();

//     await clearTable('Customer');

//     for (int i = 0; i < quotesList.length; i++) {
//       batch.insert('Customer', quotesList[i].toMap());
//     }

//     await batch.commit();
//     await updateCacheLog(CacheLog(
//       Random().nextInt(100),
//       'Customer',
//       (DateTime.now().toUtc()).toString(),
//     ));
//   }

// // Get All app labels
//   Future getCustomer() async {
//     final db = await database;
//     final labels = await db.query('Customer');

//     // Convert the List<Map<String, dynamic> into a List<Dog>.
//     return labels.isNotEmpty
//         ? List.generate(
//             labels.length,
//             (i) => Customer(
//               labels[i]['id'],
//               labels[i]['author'],
//               labels[i]['quote'],
//               labels[i]['quoteId'],
//             ),
//           )
//         : [];
//   }

//   // Delete all rows
//   Future clearTable(String tableName) async {
//     final db = await database;
//     final queryResult = await db.rawDelete('DELETE FROM $tableName');

//     return queryResult;
//   }
// }
