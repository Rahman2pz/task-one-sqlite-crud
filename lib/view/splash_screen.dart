import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:task_one/adds/add_helper.dart';
import 'package:task_one/view/dash_bord.dart';

bool isAdLoaded = false;


class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  // late AppOpenAd _appOpenAds;
  // bool isAdLoaded = false;

  late InterstitialAd _interstitialAd;


  @override
  void initState() {
   // FirebaseAnalytics.instance.setCurrentScreen(screenName: 'SpashScreen');
    super.initState();
   _createInterstitialAd();
    // loadAppOpenAd();
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
            print('class splash isAdLoaded value is = $isAdLoaded');
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



  // loadAppOpenAd() {
  //   AppOpenAd.load(
  //       adUnitId: AdHelper.appOpenAdUnitId, //Your ad Id from admob
  //       request: const AdRequest(),
  //       adLoadCallback: AppOpenAdLoadCallback(
  //           onAdLoaded: (ad) {
  //             _appOpenAds = ad;
  //             setState(() {
  //               isAdLoaded = true;
  //             });
  //           },
  //           onAdFailedToLoad: (error) {}),
  //       orientation: AppOpenAd.orientationPortrait);
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/animations/splash_screen.json'),
          ),

          Spacer(),
          ElevatedButton(
            style:ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50)
            ) ,
              onPressed: (){
              if (isAdLoaded){
                _interstitialAd.show();

                _createInterstitialAd();

                setState(() {
                  isAdLoaded = false ;
                });
              //   _appOpenAds.show();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  DashBord(),));
              }else{
                setState(() {
                  isAdLoaded = true;
                });

                _createInterstitialAd();
              }

                // FirebaseCrashlytics.instance.crash();


          }, child: const Text('Add Note',style: TextStyle(color: Colors.white),)),
          SizedBox(height: 30,)

        ],
      ),
    );
  }
}
