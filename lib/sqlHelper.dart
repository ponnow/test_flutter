import 'dart:html';

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static final DATABASE_NAME = 'notedb';
  static final VERSION = 1;
  static final TABLE_NAME = 'introduction';

  static final COL_1 = 'id';
  static final COL_2 = 'name';
  static final COL_3 = 'title';
  static final COL_4 = 'remarks';
  static final COL_5 = 'createAT';

  static Future<void> createTable(sql.Database database) async {
    String CREATE_TABLE_QUERY = 'CREATE TABLE' +
        TABLE_NAME +
        '(' +
        COL_1 +
        'INTEGER PRIMARY KEY AUTOINCREMENT,' +
        COL_2 +
        'TEXT,' +
        COL_3 +
        'TEXT,' +
        COL_4 +
        'TEXT,' +
        COL_5 +
        'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP' +
        ')';

    await database.execute(CREATE_TABLE_QUERY);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(DATABASE_NAME, version: VERSION,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  //Create new Note(Journal)

  static Future<int> createNote(String name, title, String? remarks) async {
    final db = await SQLHelper.db();

    final data = {COL_2: name, COL_3: title, COL_4: remarks};
    final id = await db.insert(TABLE_NAME, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Read all Note(Journal)

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SQLHelper.db();
    return db.query(TABLE_NAME, orderBy: 'id');
  }

  //Read single note

  static Future<List<Map<String, dynamic>>> getNote(int id) async {
    final db = await SQLHelper.db();
    return db.query(TABLE_NAME, where: 'id  =?', whereArgs: [id], limit: 1);
  }

  //Update an Note by id

  static Future<int> updateNotes(
      int id, String name, title, String? remarks) async {
    final db = await SQLHelper.db();
    final data = {
      COL_2: name,
      COL_3: title,
      COL_4: remarks,
      COL_5: DateTime.now().toString()
    };
    final result =
        await db.update(TABLE_NAME, data, where: "id", whereArgs: [id]);
    return result;
  }

  //Delete Note

  static Future<void> deleteNotes(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(TABLE_NAME, where: 'id', whereArgs: [id]);
    } catch (err) {
      print('Something went wrong : $err');
    }
  }
}
