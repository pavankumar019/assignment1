import 'dart:io';

import 'package:assignment/datamodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  final tbName = "notes";

  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Description.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE notes (
            uid INTEGER PRIMARY KEY AUTOINCREMENT ,
            title TEXT,
            description TEXT )""");
    });
  }

  Future<int> insertData(UserData userData) async {
    final db = await database;
    var result = await db!.insert(tbName, userData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> deleteData(int id) async {
    final db = await database;
    var result = await db!.delete(tbName, where: "uid = ?", whereArgs: [id]);
    return result;
  }

  Future<List<UserData>> getData() async {
    final db = await database;
    final data = await db!.query(tbName, orderBy: "uid ASC");
    List<UserData> noteList = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        noteList.add(UserData.fromMap(data[i]));
      }
    }
    return noteList;
  }

  Future<int> updateData(UserData userData) async {
    final db = await database;
    final id = userData.uid;
    int result = await db!
        .update(tbName, userData.toMap(), where: "uid = ?", whereArgs: [id]);
    return result;
  }

  Future<List<UserData>> getDataWithId(int? id) async {
    final db = await database;

    final result = await db!.query(tbName, where: "uid = ?", whereArgs: [id]);
    final resultData = result.map((e) {
      return UserData.fromMap(e);
    }).toList();
    return resultData;
  }
}
