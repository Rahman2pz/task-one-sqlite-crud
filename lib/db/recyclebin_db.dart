import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_one/db/db.dart';

class RecycleBinDB {
  final String _recycleBinTableName = 'recycle_bin';

  List<Map<String, dynamic>> _records = [];


  Future<Database> getDataBase() async {
    return openDatabase(
        join(await getDatabasesPath(), "usersDatabase.db"),
        onCreate: (db, version) async {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS $_recycleBinTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phoneNumber TEXT,
      imageUrl TEXT,
      deletionTime INTEGER
    )
''');
      },
      version: 1,
    );
    }


  Future<void> moveRecordToRecycleBin(int userId) async {
  Database db = await getDataBase();
  int deletionTime = DateTime.now().millisecondsSinceEpoch;
  // Fetch the record from the original table
  List<Map<String, Object?>> records = await db.rawQuery('SELECT * FROM ${SqliteDatabaseHelper().tableName} WHERE id = ?', [userId] );

    if (records.isNotEmpty) {
      Map<String, Object?> record = records.first;
      // final record = _records.firstWhere((record) => record['id'] == userId);
      // final TextEditingController nameController = TextEditingController(text:  record['name']);
      // Insert the recoflrd into the recycle bin table
      await db.rawInsert(
          'INSERT INTO $_recycleBinTableName (name, phoneNumber, imageUrl, deletionTime) VALUES (?, ?, ?, ?)',
          [
            record["name"],
            record['phoneNumber'],
            record['imageUrl'],
            deletionTime,
          ]);
    }
  // Delete the record from the original table
  await db.rawDelete('DELETE FROM ${SqliteDatabaseHelper().tableName}  WHERE id = ?', [userId]);
  }


}