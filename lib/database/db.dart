import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class NotesBHandler {

  final databaseName = "notes.db";
 static final tableName = "notes";


  static final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "BLOB",
    "content": "BLOB"
  };


  static Database _database;


 static Future<Database> getNoteList() async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }


 static initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, 'notes.db');
    // ignore: argument_type_not_assignable
    Database dbConnection = await openDatabase(
        dbPath, version: 1, onCreate: (Database db, int version) async {
      print("executing create query from onCreate callback");
      await db.execute(_buildCreateQuery());
    });

    await dbConnection.execute(_buildCreateQuery());
    _buildCreateQuery();
    return dbConnection;
  }


// build the create query dynamically using the column:field dictionary.
  static String _buildCreateQuery() {
    String query = "CREATE TABLE IF NOT EXISTS ";
    query += tableName;
    query += "(";
    fieldMap.forEach((column, field){
      print("$column : $field");
      query += "$column $field,";
    });


    query = query.substring(0, query.length-1);
    query += " )";

   return query;

  }

  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }

  static Future insertNote(Map<String, dynamic> note) async {
    // Insert the Notes into the correct table.
    await _database.insert('notes', note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // static Future<bool> copyNote(Map<String, dynamic> note) async {
  //   final Database db = await database;
  //   try {
  //     await db.insert("notes", note, conflictAlgorithm: ConflictAlgorithm.replace);
  //   } catch(Error) {
  //     print(Error);
  //     return false;
  //   }
  //   return true;
  // }


  // Future<bool> archiveNote(Note note) async {
  //   if (note.id != -1) {
  //     final Database db = await database;

  //     int idToUpdate = note.id;

  //     db.update("notes", note.toMap(true), where: "id = ?",
  //         whereArgs: [idToUpdate]);
  //   }
  // }

  static Future<bool> deleteNote(int id) async {
      try {
        await _database.delete("notes",where: "id = ?",whereArgs: [id]);
        return true;
      } catch (Error){
        print("Error deleting $id: ${Error.toString()}");
        return false;
      }
    }
  }


  // Future<List<Map<String,dynamic>>> selectAllNotes() async {
  //   final Database db = await database;
  //   // query all the notes sorted by last edited
  //   var data = await db.query("notes", orderBy: "date_last_edited desc",
  //       where: "is_archived = ?",
  //       whereArgs: [0]);

  //   return data;

  // }





