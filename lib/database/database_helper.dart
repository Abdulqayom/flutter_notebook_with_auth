import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqfliteauth/JSON/note.dart';
import 'package:flutter/foundation.dart';

import '../JSON/users.dart';

class DatabaseHelper {
  final databaseName = "auth.db";

  //Tables

  //Don't put a comma at the end of a column in sqlite

  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT,
   usrImage TEXT,
   usrName TEXT UNIQUE,
   usrPassword TEXT
   )
   ''';
  // String admin = '''
  //  CREATE TABLE admin (
  //  adminId INTEGER PRIMARY KEY AUTOINCREMENT,

  //  usrName TEXT,
  //  usrPassword TEXT
  //  )
  //  ''';
  String note = '''
      CREATE TABLE notes (
        notId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        description TEXT,
        image TEXT,  -- assuming image is stored as a file path
        FOREIGN KEY (userId) REFERENCES users (usrId) ON DELETE CASCADE
      )
    ''';
  // String adminData =
  //     "insert into admin (adminId, usrName, usrPassword) values(null,'silab','silab')";

  //Our connection is ready
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(user);
      // await db.execute(admin);

      // await db.rawQuery(adminData);

      await db.execute(note);
    });
  }

  //Function methods

  //Authentication
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  Future<int> createNote(Note note) async {
    final Database db = await initDB();
    return db.insert("notes", note.toMap());
  }

  //Get current User details
  Future<Users?> getUser(String usrName) async {
    final Database db = await initDB();
    var res =
        await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<int?> totalNotes(int userId) async {
    final Database db = await initDB();
    final count = Sqflite.firstIntValue(await db
        .rawQuery("select count(*) from notes where userId = [$userId]"));
    return count;
  }

  Future<int?> totalUsers() async {
    final Database db = await initDB();
    final count =
        Sqflite.firstIntValue(await db.rawQuery("select count(*) from users "));
    return count;
  }

  Future<Note?> getNotebyUser(int usrid) async {
    final Database db = await initDB();
    var res = await db.query("notes", where: "userId = ?", whereArgs: [usrid]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  Future<List<Note>> getNotesbyUser(int usrId) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("notes", where: "userId = ?", whereArgs: [usrId]);

    // final List<Map<String, Object?>> queryResult =
    //     await db.query('notes', orderBy: 'userId');
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  Future<List<Users>> getUsersbyId() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        // await db.rawQuery("select count(*) from users ");
        await db.query("users", orderBy: "usrId",);

    //   // await db.query("users", where: "usrName = ?", whereArgs: ['Silab']);

    //   // final List<Map<String, Object?>> queryResult =
    //   //     await db.query('notes', orderBy: 'userId');
    return queryResult.map((e) => Users.fromMap(e)).toList();
  }

  Future<void> deleteUser(String id) async {
    final db = await initDB();
    try {
      await db.delete("users", where: "usrId = ?", whereArgs: [id]);
    } catch (err) {
      if (kDebugMode) {
        print("deleting failed: $err");
      }
    }
  }

  Future<void> deleteNotes(String userId) async {
    final db = await initDB();
    try {
      await db.delete("notes", where: "userId = ?", whereArgs: [userId]);
    } catch (err) {
      if (kDebugMode) {
        print("deleting failed: $err");
      }
    }
  }

  Future<int> updateUser(Users users) async {
    final Database db = await initDB();
    var result = await db.update('users', users.toMap(),
        where: 'usrId = ?', whereArgs: [users.usrId]);
    return result;
  }

  Future<int> updateNote(Note notes) async {
    final Database db = await initDB();
    var result = await db.update('notes', notes.toMap(),
        where: 'notId = ?', whereArgs: [notes.notId]);
    return result;
  }
}
