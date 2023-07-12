import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:task_one/provider/AdsProvider/ads_provider.dart';
import 'package:task_one/firebase_options.dart';
import 'package:task_one/provider/DBProvier/db_provider.dart';
import 'package:task_one/provider/DBProvier/recyclebin_provider.dart';
import 'package:task_one/view/dash_bord.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:task_one/view/splash_screen.dart';
// import 'package:flutter_core';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  MobileAds.instance
    ..initialize()
    ..updateRequestConfiguration(
      RequestConfiguration(
          testDeviceIds: ['7C92BD192385F05DDBD6FC73370E2D63']),
    );
  // Elsewhere in your code
  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp(

  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>  AdsProvider()),
        ChangeNotifierProvider(create: (context) =>  DBProvider()),
        ChangeNotifierProvider(create: (context) => RecycleBinProvider()),
      ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const SpashScreen(),
      ),
    );
  }
}
