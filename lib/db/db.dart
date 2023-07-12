// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';
// // import 'package:sqflite/sqflite.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_one/model/user.dart';


class SqliteDatabaseHelper{

  final String tableName = "users";

  Future<Database> getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), "usersDatabase.db"),
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phNumber TEXT,
      imageUrl TEXT,
      isDeleted INTEGER DEFAULT 0
    )
  ''');
      },
      version: 1,
    );
  }

  Future<int> insertUser(User user) async {
    int userId = 0;
    Database db = await getDataBase();
    await db.insert( tableName, user.toMap()).then((value) {
      userId = value;
    });
    return userId;
  }


  Future<List<User>> getAllUsers() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> usersMaps = await db.rawQuery('SELECT * FROM $tableName WHERE isDeleted = 0');
    return List.generate(usersMaps.length, (index) {
      return User(
        id: usersMaps[index]['id'],
        name: usersMaps[index]['name'],
        phNumber: usersMaps[index]['phNumber'],
        imageUrl: usersMaps[index]['imageUrl'],
      );
    });
  }


  Future<User?> getUserById(int userId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }


  Future<List<User>> getDeletedUsers() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'isDeleted = 1',
    );
    List<User> deletedUsers = [];
    if (result.isNotEmpty) {
      for (var item in result) {
        deletedUsers.add(User.fromMap(item));
      }
    }
    return deletedUsers;
  }

  Future<void> deleteUser(int userId) async {
    Database db = await getDataBase();
    await db.rawUpdate('UPDATE $tableName SET isDeleted = 1 WHERE id = ?', [userId]);
  }


  Future<int> updateData(User user) async {
    final Database db = await getDataBase();
    return await db.update(tableName, user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> restoreUser(int userId) async {
    Database db = await getDataBase();
    await db.rawUpdate('UPDATE $tableName SET isDeleted = 0 WHERE id = ?', [userId]);
  }

  Future<void> permanentDeleteUser(int userId) async {
    Database db = await getDataBase();
    await db.rawDelete('DELETE FROM $tableName WHERE id = ?', [userId]);
  }


}



