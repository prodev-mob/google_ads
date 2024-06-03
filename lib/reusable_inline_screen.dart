import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReusableInlineScreen extends StatefulWidget {
  const ReusableInlineScreen({super.key,});

  @override
  ReusableInlineScreenState createState() => ReusableInlineScreenState();
}

class ReusableInlineScreenState extends State<ReusableInlineScreen> {

  AdManagerBannerAd? _adManagerBannerAd;
  bool _adManagerBannerAdIsLoaded = false;

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 20,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 0,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final AdManagerBannerAd? adManagerBannerAd = _adManagerBannerAd;
            if (index == 10 &&
                _adManagerBannerAdIsLoaded &&
                adManagerBannerAd != null) {
              return SizedBox(
                  height: adManagerBannerAd.sizes[0].height.toDouble(),
                  width: adManagerBannerAd.sizes[0].width.toDouble(),
                  child: AdWidget(ad: _adManagerBannerAd!));
            }

            final NativeAd? nativeAd = _nativeAd;
            if (index == 15 && _nativeAdIsLoaded && nativeAd != null) {
              return SizedBox(
                  width: 250, height: 350, child: AdWidget(ad: nativeAd));
            }

            return const Text(
              // Constants.placeholderText,
              "",
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511',
      request: const AdRequest(),
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
      ),
    )..load();

    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: '/6499/example/banner',
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[AdSize.largeBanner],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$AdManagerBannerAd loaded.');
          setState(() {
            _adManagerBannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$AdManagerBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$AdManagerBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$AdManagerBannerAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _adManagerBannerAd?.dispose();
    _nativeAd?.dispose();
  }
}