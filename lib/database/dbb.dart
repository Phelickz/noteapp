
import 'dart:async';
import 'dart:io';

import 'package:noteapp/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase{
  NotesDatabase._();
  static final NotesDatabase db = NotesDatabase._();


  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, 'Notes.db');
    // ignore: argument_type_not_assignable
    return await openDatabase(
        dbPath, version: 1, onCreate: (Database db, int version) async {
      print("executing create query from onCreate callback");
      await db.execute('''
        create table Notes(
          id integer primary key autoincrement,
          title text,
          content content not null
        );
      ''');
    });
  }

  Future<List<Note>> getAllClients() async {
    final db = await database;
    var res = await db.query("Notes");
    List<Note> list =
      res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
      print(list);

  return list; 
      
    }

    Future<void> insertNote(Note note) async {
      // Get a reference to the database.
      final Database db = await database;

      // Insert the Dog into the correct table. Also specify the
      // `conflictAlgorithm`. In this case, if the same dog is inserted
      // multiple times, it replaces the previous data.
      await db.insert(
        'Notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<List<Note>> notes() async {
      // Get a reference to the database.
      final Database db = await database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('Notes');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Note(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content'],
        );
      });
    }

    Future<void> updateNote(Note note) async {
      // Get a reference to the database.
      final Database db = await database;
      print('update called');
      // Update the given Dog.
      await db.update(
        'Notes',
        note.toMap(),
        // Ensure that the Dog has a matching id.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [note.id],
      );
      print('update finished');
    }

    Future<void> deleteNote(int id) async {
      // Get a reference to the database.
      final db = await database;

      // Remove the Dog from the database.
      await db.delete(
        'Notes',
        // Use a `where` clause to delete a specific dog.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }


    // var fido = Dog(
    //   id: 0,
    //   name: 'Fido',
    //   age: 35,
    // );

    // // Insert a dog into the database.
    // await insertDog(fido);

    // // Print the list of dogs (only Fido for now).
    // print(await dogs());

    // // Update Fido's age and save it to the database.
    // fido = Dog(
    //   id: fido.id,
    //   name: fido.name,
    //   age: fido.age + 7,
    // );
    // await updateDog(fido);

    // // Print Fido's updated information.
    // print(await dogs());

    // // Delete Fido from the database.
    // await deleteDog(fido.id);

    // // Print the list of dogs (empty).
    // print(await dogs());

  newNote(Note newNote) async {
    final db = await database;
    var res = await db.insert("Notes", newNote.toMap());
    return res;
  }

  getNote(int id) async{
    final db = await database;
    var res = await db.query('Notes', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : Null;
  }


}

