import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';

class RecycleBinScreen extends StatefulWidget {
  @override
  _RecycleBinScreenState createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  List<User> _deletedUsers = [];

  @override
  void initState() {
    super.initState();
    getDeletedUsers();
  }

  void getDeletedUsers() async {
    _deletedUsers = await SqliteDatabaseHelper().getDeletedUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin'),
      ),
      body: _deletedUsers.isNotEmpty ?
      ListView.builder(
        itemCount: _deletedUsers.length,
        itemBuilder: (context, index) {
          User user = _deletedUsers[index];
          return ListTile(
            title: Text(user.name.toString()),
            subtitle: Text(user.phNumber.toString()),
            leading: CircleAvatar(
              backgroundImage: FileImage(File(user.imageUrl.toString())),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _restoreUser(user.id!.toInt());
                  },
                  icon: const Icon(Icons.restore),
                ),
                IconButton(
                  onPressed: () {
                    _permanentDeleteUser(user.id!.toInt());
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            ),
          );
        },
      ): const Center(child: Text('Data is Empty', style: TextStyle(fontSize: 18),))
    );
  }

  void _restoreUser(int userId) async {
    await SqliteDatabaseHelper().restoreUser(userId);
    setState(() {
      _deletedUsers.removeWhere((user) => user.id == userId);
    });
  }

  void _permanentDeleteUser(int userId) async {
    await SqliteDatabaseHelper().permanentDeleteUser(userId);
    setState(() {
      _deletedUsers.removeWhere((user) => user.id == userId);
    });
  }
}
