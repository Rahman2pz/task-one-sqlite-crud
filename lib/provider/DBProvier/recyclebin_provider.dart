import 'package:flutter/cupertino.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';

class RecycleBinProvider extends ChangeNotifier{
  List<User> _deletedUsers = [];
  SqliteDatabaseHelper sqliteDatabaseHelper  = SqliteDatabaseHelper();

  List<User> get deleteUsers => _deletedUsers;

  Future<void> getDeletedUsers() async  {
    _deletedUsers = await sqliteDatabaseHelper.getDeletedUsers();
    notifyListeners();
  }

  Future<void> restoreUser(int userId) async {
    await SqliteDatabaseHelper().restoreUser(userId);
      _deletedUsers.removeWhere((user) => user.id == userId);
      notifyListeners();
  }

  Future<void> permanentDeleteUser(int userId) async {
    await SqliteDatabaseHelper().permanentDeleteUser(userId);
    // setState(() {
      _deletedUsers.removeWhere((user) => user.id == userId);
      notifyListeners();
    // });
  }
}