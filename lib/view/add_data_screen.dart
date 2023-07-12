import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_one/ads/add_helper.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';
import 'package:task_one/provider/AdsProvider/ads_provider.dart';
import 'package:task_one/provider/DBProvier/db_provider.dart';
import 'package:task_one/view/splash_screen.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {

  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  File? _pickImageSelect;


  @override
  void initState() {
    super.initState();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.loadBannerAd();
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
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.bannerAd.dispose();
    adsProvider.interstitialAd!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DBProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF6F5F5),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Add Data',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                _pickImageSelect == null
                    ? Container(height: 70, width: 70,decoration: const BoxDecoration(
                  // color: Colors.blue,
                  shape: BoxShape.circle,

                ),
                  child: Image.asset('assets/images/profile dp.png'),
                )
                    : CircleAvatar(
                      radius:50,
                      backgroundImage: FileImage(_pickImageSelect!),
                    ),



                TextButton(onPressed: (){
                  imageSelected();
                }, child: const Text('Select your image')
                ),

                Form(
                  key: _form,
                    child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'Add your Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Field is empty' ;
                        }
                        return null ;

                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                          hintText: 'phone Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Field is empty' ;
                        }
                        return null ;

                      },
                    ),
                  ],
                )),

                const SizedBox(height: 20),
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    // maximumSize: Size(150, 50),
                    minimumSize: Size(MediaQuery.of(context).size.width  * 1, 50),
                  ),
                    onPressed: (){
                    addDatas();

                },
                    child:const Text('Add Data',style: TextStyle(color: Colors.white),)),
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar:adsProvider.isBannerAdReady ? SizedBox(
          height: adsProvider.bannerAd.size.height.toDouble(),
          width: adsProvider.bannerAd.size.width.toDouble(),
          child: AdWidget(ad: adsProvider.bannerAd),
        ): const SizedBox()


    );
  }

  void addDatas(){
    final dbProvider = Provider.of<DBProvider>(context,listen: false);
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    if (_form.currentState!.validate() && adsProvider.isBannerAdReady){
      String? imagePath;
      if (_pickImageSelect != null) {
        imagePath = _pickImageSelect!.path;
      } else {
        imagePath = '';
      }
      dbProvider.addUser( User(
        name: nameController.text,
        phNumber: phoneController.text,
        imageUrl: imagePath,
      )).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add data ${nameController.text}')));
        debugPrint("path image : $imagePath");
        // setState(() {
        nameController.clear();
        phoneController.clear();
        _pickImageSelect = null ;
        // });
      });
      adsProvider.showInterstitialAd();
    }else{
      String? imagePath;
      if (_pickImageSelect != null) {
        imagePath = _pickImageSelect!.path;
      } else {
        imagePath = '';
      }
      dbProvider.addUser( User(
        name: nameController.text,
        phNumber: phoneController.text,
        imageUrl: imagePath,
      )).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add data ${nameController.text}')));
        debugPrint("path image : $imagePath");
        setState(() {
          nameController.clear();
          phoneController.clear();
          _pickImageSelect = null ;
        });
      });


    }
  }
}
