import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_one/provider/AdsProvider/ads_provider.dart';
import 'package:task_one/ads/add_helper.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';
import 'package:task_one/provider/DBProvier/db_provider.dart';

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

  // TODO: Add _kAdIndex
  static const _kAdIndex = 4;

  @override
  void initState() {
    super.initState();
    final adsProvider = Provider.of<AdsProvider>(context,listen: false);
    Future.delayed(const Duration(seconds: 1), () {
      adsProvider.loadNativeAdTwo();
    },);
    final dbProvider = Provider.of<DBProvider>(context, listen:  false);
    dbProvider.loadUser();
    // _loadUsers();
  }

    // Future<void> _loadUsers() async {
    //   final dbProvider = Provider.of<DBProvider>(context, listen:  false);
    //   dbProvider.loadUser();
    // }

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
  void dispose() {
    super.dispose();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.nativeAdTwo!.dispose();
    nameController.dispose();
    phoneController.dispose();
  }
  // int itemCount = userList.length + (adsProvider.isNativeAdLoaded ? 1 : 0);
    @override
    Widget build(BuildContext context) {
      final adsProvider= Provider.of<AdsProvider>(context);
      final dbProvider= Provider.of<DBProvider>(context);
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            title: const Text('User List', style: TextStyle(color: Colors.white)),
          ),
          body: dbProvider.userList.isNotEmpty ?
          ListView.builder(
            // reverse: true,
            itemCount: dbProvider.userList.length ,
            itemBuilder: (context, index) {
              // print(userList.length);
              int userListIndex = index - (index ~/ 4);
              User user = dbProvider.userList[index];
              // User user = userList[index];
              if (adsProvider.isNativeAdLoadedTwo && adsProvider.nativeAdTwo != null && index == _kAdIndex) {
                // int userListIndex = index - (index ~/ 4);
                User user = dbProvider.userList[index];
                return Container(
                  height: 72.0,
                  alignment: Alignment.center,
                  child: AdWidget(ad: adsProvider.nativeAdTwo!),
                );
              }
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(user.imageUrl.toString())),
                    ),
                    title: Text(user.name.toString()),
                    subtitle: Text('phone: ${user.phNumber}'),
                    trailing: PopupMenuButton(
                      onSelected: (String value) {
                        if (value == 'delete') {
                          dbProvider.deleteUser(context,user.id!.toInt());
                        } else if (value == 'update') {
                          _showBottomSheet(context, user.id!.toInt(), user.name.toString(),
                              user.phNumber.toString(), user.imageUrl.toString());
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                              value: 'delete',
                              child: Text('delete')),
                          const PopupMenuItem(
                              value: 'update',
                              child: Text('update')),

                        ];
                      },)

                  ),
                );
              }
          ):const  Center(child:  Text('Data is Empty', style: TextStyle(fontSize: 18)))
      );
    }

  void _showBottomSheet(BuildContext context,int id, String name, String phoneNumber, String imageUrl) {
    nameController.text = name;
    // or
    // final nameController = TextEditingController(text: name);
    phoneController.text = phoneNumber;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: nameController,
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle update action
                  final dbProvider = Provider.of<DBProvider>(context,listen:  false);
                  dbProvider.updateData(id, nameController.text, phoneController.text,imageUrl);
                  Navigator.pop(context);
                },
                child: Text('Update'),
              ),
            ],
          ),
        );
      },
    );
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



