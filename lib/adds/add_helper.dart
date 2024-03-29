import 'dart:io';

class AdHelper {
static String get bannerAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

static String get interstitialAdUnitId{
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  } else if (Platform.isIOS) {
    return '';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

static String get appOpenAdUnitId{
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/3419835294';
  } else if (Platform.isIOS) {
    return '';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}
static String get nativeAdUnitId{
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/2247696110';
  } else if (Platform.isIOS) {
    return '';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

}
//--- Call like this ----
// _bannerAd = BannerAd(
// adUnitId: AdHelper.bannerAdUnitId,
// );