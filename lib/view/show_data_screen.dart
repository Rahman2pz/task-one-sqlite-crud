import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_one/adds/add_helper.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';

class ShowDataScreen extends StatefulWidget {
  @override
  _ShowDataScreenState createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  List<User> userList = [];
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  File? _pickImageSelect;



  @override
  void initState() {
    super.initState();
    _loadUsers();
  }



    Future<void> _loadUsers() async {
      List<User> users = await SqliteDatabaseHelper().getAllUsers();
      setState(() {
        userList = users;
      });
    }

    void imageSelected() async{
      final ImagePicker picker = ImagePicker();
// Pick an image.
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null){
        setState(() {
          _pickImageSelect = File(image.path);
          print(_pickImageSelect);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            title: const Text('User List', style: TextStyle(color: Colors.white)),
          ),
          body: userList.isNotEmpty ?
          ListView.builder(
            // reverse: true,
            itemCount: userList.length,
            itemBuilder: (context, index) {
              User user = userList[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(user.imageUrl.toString())),
                  ),
                  title: Text(user.name.toString()),
                  subtitle: Text('phone: ${user.phNumber}'),
                  trailing: SizedBox(
                    width: 70,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: IconButton(
                            // update
                            onPressed: (){
                              _showUpdateBottomSheet(context,userList[index].id!.toInt(), user.name.toString(), user.phNumber.toString() );
                            },icon: const Icon(Icons.edit),
                          ),
                        ),
                        // SizedBox(width: 3),
                        Expanded(
                          child: IconButton(onPressed: (){
                            setState(() {
                              SqliteDatabaseHelper().deleteUser(user.id!.toInt()).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data is remove')));
                                setState(() {
                                  userList.remove(user);
                                });
                              });
                            });
                          },icon: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ):const  Center(child:  Text('Data is Empty', style: TextStyle(fontSize: 18)))
      );
    }

    void _showUpdateBottomSheet(BuildContext context, int userId, String name, String phNumber) {
      nameController.text = name;
      phoneController.text = phNumber;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // String updatedName = '';
          // String updatedPhNumber = '';
          // String updatedImageUrl = '';

          return Container(
            // Bottom sheet content
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,

                          // onChanged: (value) {
                          //   updatedName = value;
                          // },
                          decoration:const  InputDecoration(
                              hintText: 'name'
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: phoneController,
                    // onChanged: (value) {
                    //   updatedPhNumber = value;
                    // },
                    decoration:const InputDecoration(
                      labelText: 'phone',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // if (_form.currentState!.validate()){
                      //   // Close the bottom sheet
                      // }

                      _updateUser(userId, nameController.text, phoneController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void _updateUser(int userId, String name, String phNumber) async {
      Database db = await SqliteDatabaseHelper().getDataBase();

      String query = "UPDATE ${SqliteDatabaseHelper().tableName} SET name = '$name', phNumber = '$phNumber' WHERE id = $userId";
      await db.rawUpdate(query);
      // Fetch the updated user data from the database
      User? updatedUser = await SqliteDatabaseHelper().getUserById(userId);

      setState(() {
        int index = userList.indexWhere((user) => user.id == userId);
        if (index != -1) {
          userList[index] = updatedUser!;
        }
        // Update the necessary state variables
        // that are used to display the updated data in the UI
      });
    }

    Future<User?> getUserById(int userId) async {
      Database db = await SqliteDatabaseHelper().getDataBase();
      List<Map<String, dynamic>> result = await db.query(
        '${SqliteDatabaseHelper().tableName}',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
    }

  }



