import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_one/adds/add_helper.dart';
import 'package:task_one/db/db.dart';
import 'package:task_one/model/user.dart';
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

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  late InterstitialAd _interstitialAd;
  // bool isAdLoaded = false;

  @override
  void initState() {
    _createInterstitialAd();
    _loadBannerAd();
    super.initState();

  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }






  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(), // request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            setState(() {
              isAdLoaded = !isAdLoaded;
            });
            print('class add Data isAdLoaded value is = $isAdLoaded');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('isLoad $isAdLoaded')));
            // _numInterstitialLoadAttempts = 0;
            // _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _interstitialAd.dispose();
            // _numInterstitialLoadAttempts += 1;
            // _interstitialAd = null;
            // if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            //   _createInterstitialAd();
            // }
          },
        ));
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F5F5),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Add Data',style: TextStyle(color: Colors.white),),
      ),
      body: Center(
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
                  // if (isAdLoaded){
                  //   _interstitialAd.show();
                  // }

                  if (_form.currentState!.validate() && isAdLoaded){
                    String? imagePath;
                    if (_pickImageSelect != null) {
                      imagePath = _pickImageSelect!.path;
                    } else {
                      imagePath = '';
                    }
                    SqliteDatabaseHelper().insertUser(
                        User(
                      name: nameController.text,
                      phNumber: phoneController.text,
                      imageUrl: imagePath,
                    )).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add data ${nameController.text}')));
                      debugPrint("path image : $imagePath");
                      setState(() {

                        nameController.clear();
                        phoneController.clear();
                        _pickImageSelect!.path.isEmpty;
                      });
                    });
                    _interstitialAd.show();
                  }else{
                    String? imagePath;
                    if (_pickImageSelect != null) {
                      imagePath = _pickImageSelect!.path;
                    } else {
                      imagePath = '';
                    }
                    SqliteDatabaseHelper().insertUser(
                        User(
                          name: nameController.text,
                          phNumber: phoneController.text,
                          imageUrl: imagePath,
                        )).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add data ${nameController.text}')));
                      debugPrint("path image : $imagePath");
                      setState(() {
                        nameController.clear();
                        phoneController.clear();
                        _pickImageSelect!.path.isEmpty;
                      });
                    });
                  }

              },
                  child:const Text('Add Data',style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
      ),
        bottomNavigationBar: _isBannerAdReady ? SizedBox(
          height: _bannerAd.size.height.toDouble(),
          width: _bannerAd.size.width.toDouble(),
          child: AdWidget(ad: _bannerAd),
        ): const SizedBox()


    );
  }
}
