import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:task_one/provider/AdsProvider/ads_provider.dart';
import 'package:task_one/ads/add_helper.dart';
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
  @override
  void initState() {
    super.initState();
    final adsProvider = Provider.of<AdsProvider>(context,listen: false);
    Future.delayed(const Duration(seconds: 3), () {
      adsProvider.loadNativeAd();
    },);
  }

  @override
  void dispose() {
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.nativeAd!.dispose();
    adsProvider.interstitialAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'DashBord',
          style: TextStyle(color: Colors.white),
        ),
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
                    onTap: () {
                      if (adsProvider.isInterstitialAdLoad) {
                        adsProvider.showInterstitialAd();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddDataScreen(),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddDataScreen(),
                            ));
                      }
                    },
                    child: const Card(
                        child: DashBordCard(
                      text: 'Create Note',
                      icon: Icons.edit,
                    )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (adsProvider.isInterstitialAdLoad) {
                        adsProvider.showInterstitialAd();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDataScreen(),
                            ));
                      } else {
                        // _createInterstitialAd();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDataScreen(),
                            ));
                      }
                    },
                    child: const Card(
                        child: DashBordCard(
                      text: 'Show Note',
                      icon: Icons.speaker_notes,
                    )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (adsProvider.isInterstitialAdLoad) {
                        adsProvider.showInterstitialAd();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecycleBinScreen(),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecycleBinScreen(),
                            ));
                      }
                    },
                    child: const Card(
                        child: DashBordCard(
                      text: 'Recycle Bin',
                      icon: Icons.recycling_outlined,
                    )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowDataScreen(),
                          ));
                    },
                    child: Card(
                        child: DashBordCard(
                      text: 'Shared',
                      icon: Icons.share,
                    )),
                  ),
                ],
              ),
              Spacer(),
              adsProvider.isNativeAdLoaded
                  ? Container(
                      height: 100.0,
                      alignment: Alignment.center,
                      child: AdWidget(ad: adsProvider.nativeAd!),
                    )
                  : SizedBox(),
              const SizedBox(height: 65),
            ],
          ),
        ),
      ),
    );
  }
}
