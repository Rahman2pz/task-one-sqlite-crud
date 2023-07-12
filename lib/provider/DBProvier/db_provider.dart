import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';

class DBProvider extends ChangeNotifier{
  List<User> usersList = [];
  User user = const User();
  SqliteDatabaseHelper sqliteDatabaseHelper = SqliteDatabaseHelper();

  List<User> get userList => usersList;

  Future<void> loadUser() async {
    List<User> users = await SqliteDatabaseHelper().getAllUsers();
    usersList = users;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await SqliteDatabaseHelper().insertUser(user);
    await loadUser();
    notifyListeners();
  }


  Future<void> updateData(int id, String name, String phNumber, String imageUrl) async {
    sqliteDatabaseHelper.updateData(User(id:  id, name: name, phNumber: phNumber,imageUrl: imageUrl)).then((value) {
      print('Data updated successfully');
      // loadUser();
    });
    notifyListeners();
    loadUser();
  }

  Future<void> deleteUser(BuildContext context,  int userId) async {
    SqliteDatabaseHelper().deleteUser(userId).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data is remove')));
        userList.remove(user);
        notifyListeners();
     loadUser();
  });
  }

}