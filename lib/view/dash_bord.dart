import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_one/adds/add_helper.dart';
import 'package:task_one/view/recyclebin_screen.dart';
import 'package:task_one/view/show_data_screen.dart';
import 'package:task_one/view/splash_screen.dart';
import 'package:task_one/widgets/dashbord_card.dart';
import 'add_data_screen.dart';

class DashBord extends StatefulWidget {
   DashBord({super.key});

  @override
  State<DashBord> createState() => _DashBordState();
}

class _DashBordState extends State<DashBord> {

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  late InterstitialAd _interstitialAd;

  @override
  void initState() {

    nativeLoadAd();
    _createInterstitialAd();
    super.initState();

  }


  // @override
  // void didUpdateWidget(covariant DashBord oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _createInterstitialAd();
  // }



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
            print('class dash isAdLoaded value is = $isAdLoaded');
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

  void nativeLoadAd() {
    nativeAd =  NativeAd(
        adUnitId: AdHelper.nativeAdUnitId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.medium,
          // Optional: Customize the ad's style.
          mainBackgroundColor: const Color(0xffEBECF0),
          cornerRadius: 10.0,

          callToActionTextStyle: NativeTemplateTextStyle(
              textColor: Colors.cyan,
              backgroundColor: Colors.red,
              style: NativeTemplateFontStyle.monospace,
              size: 16.0),
          primaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.red,
              backgroundColor: const Color(0xffEBECF0),
              style: NativeTemplateFontStyle.italic,
              size: 16.0),
          secondaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.green,
              backgroundColor: Colors.black,
              style: NativeTemplateFontStyle.bold,
              size: 16.0),
          tertiaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.brown,

              backgroundColor:const Color(0xffEBECF0),
              style: NativeTemplateFontStyle.normal,
              size: 16.0),
        )


    );
    nativeAd!.load();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: const Drawer(

      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('DashBord',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
             const SizedBox(height: 5),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 GestureDetector(
                   onTap: (){
                     if (isAdLoaded){
                       _interstitialAd.show();
                       _createInterstitialAd();
                       setState(() {
                         isAdLoaded = false ;
                       });
                       Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddDataScreen(),));
                     }else{
                       setState(() {
                         isAdLoaded = true;
                       });
                       _createInterstitialAd();
                       Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddDataScreen(),));
                     }

                   },
                   child: const Card(
                     child: DashBordCard(text: 'Create Note',icon: Icons.edit,)
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) =>  ShowDataScreen(),));

                   },
                   child: const Card(
                     child: DashBordCard(text: 'Show Note',icon: Icons.speaker_notes,)
                   ),
                 ),
               ],
             ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  RecycleBinScreen(),));

                    },
                    child: const Card(
                      child: DashBordCard(text: 'Recycle Bin',icon: Icons.recycling_outlined,)
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ShowDataScreen(),));

                    },
                    child: Card(
                      child: DashBordCard(text: 'Shared',icon: Icons.share,)
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              _nativeAdIsLoaded
                  ? SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.9, // Adjust the width based on the screen width
                  height: MediaQuery.of(context).size.height *
                      0.6, // Adjust the height based on the screen height

                  child: AdWidget(ad: nativeAd!))
                  : SizedBox(),
            ],
          ),
        ),
      ),


    );
  }
}
