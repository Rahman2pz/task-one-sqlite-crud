import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_one/ads/add_helper.dart';

class AdsProvider with ChangeNotifier{
  late BannerAd _bannerAd;
   bool _isBannerAdReady = false;
  InterstitialAd? _interstitialAd;
   bool _isInterstitialAdLoaded = false;
  NativeAd? _nativeAd;
   bool _isNativeAdLoaded = false;
  NativeAd? _nativeAdTwo;
  bool _isNativeAdLoadedTwo = false;
  bool _isInterstitialAdShown = false;

  bool get isBannerAdReady => _isBannerAdReady;
  bool get isInterstitialAdLoad => _isInterstitialAdLoaded;
  bool get isNativeAdLoaded => _isNativeAdLoaded;
  bool get isNativeAdLoadedTwo => _isNativeAdLoadedTwo;
  InterstitialAd? get interstitialAd => _interstitialAd;
  NativeAd? get nativeAd => _nativeAd;
  NativeAd? get nativeAdTwo => _nativeAdTwo;
  BannerAd get bannerAd => _bannerAd;

  AdsProvider() {
    loadBannerAd();
    _loadInterstitialAd();
    loadNativeAd();
  }

  void loadBannerAd(){
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _isBannerAdReady = true;
            notifyListeners();
          },
          onAdOpened: (ad) {
            _isNativeAdLoaded = false;
            _isInterstitialAdLoaded = false;
            notifyListeners();
          },
          onAdClosed: (ad) {
            _isNativeAdLoaded = true;
            _isInterstitialAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            _isBannerAdReady = false;
            _bannerAd.dispose();
            notifyListeners();
          },
        ) ,
       );
    _bannerAd.load();
  }

  void _loadInterstitialAd(){
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {
                  _isBannerAdReady = false;
                  _isNativeAdLoaded = false;
                  notifyListeners();
                },
                onAdDismissedFullScreenContent: (ad) {
                  _isBannerAdReady = true;
                  _isNativeAdLoaded = true;
                  notifyListeners();
                },
              );
              _interstitialAd = ad;
              _isInterstitialAdLoaded = true;
              print('****************************************');
              print(_isInterstitialAdLoaded);
              notifyListeners();
            },

            onAdFailedToLoad: (error) {
            _isInterstitialAdLoaded = false;
            notifyListeners();
            },
        )
    );
  }

  void loadNativeAd() {
    _nativeAd = NativeAd(
      factoryId: 'listTile',
      adUnitId: AdHelper.nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAd loaded.');
          _isNativeAdLoaded = true;
          notifyListeners();
        },
        onAdOpened: (ad) {
          _isInterstitialAdLoaded = false;
          _isBannerAdReady = false;
          notifyListeners();
        },
        onAdClosed: (ad) {
          _isInterstitialAdLoaded = true;
          _isBannerAdReady = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
          notifyListeners();
        },
      ),
    );
    _nativeAd!.load();
  }

  void loadNativeAdTwo() {
    _nativeAdTwo = NativeAd(
      factoryId: 'listTile',
      adUnitId: AdHelper.nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAd loaded.');
          _isNativeAdLoadedTwo = true;
          notifyListeners();
        },
        onAdOpened: (ad) {
          _isInterstitialAdLoaded = false;
          _isBannerAdReady = false;
          notifyListeners();
        },
        onAdClosed: (ad) {
          _isInterstitialAdLoaded = true;
          _isBannerAdReady = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
          notifyListeners();
        },
      ),
    );
    _nativeAdTwo!.load();
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && !_isInterstitialAdShown) {
      _interstitialAd!.show();
      _isInterstitialAdShown = true;
      _loadInterstitialAd();
      notifyListeners();
      // Reset the flag after a delay of 3 seconds (adjust the duration as needed)
      // Future.delayed(const Duration(seconds: 10), () {
      //   _isInterstitialAdShown = false;
      //   notifyListeners();
      // });
    }else if (_isInterstitialAdShown) {
      _loadInterstitialAd(); // Load a new interstitial ad for the next time
      _isInterstitialAdShown = false;
      notifyListeners();
    }
  }
}