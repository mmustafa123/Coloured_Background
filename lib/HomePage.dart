import 'dart:io';
import 'ColourScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagePath = "";
  final picker = ImagePicker();
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );


  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;


  @override
  void initState() {
    super.initState();
    /* _createInterstitialAd();
    _createRewardedAd();*/
    _createNativeBanner(context);
  }


  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }


  Future<void> _createNativeBanner(BuildContext context) async {

    final NativeAd native = NativeAd(
      request: request,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAd = ad as NativeAd?;
            _nativeAdIsLoaded = true;
              });

          },

        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ), factoryId: 'nativeAd',

    )..load();
    return native.load();
  }


  @override
  void dispose() {
    super.dispose();
    // _interstitialAd?.dispose();
    // _rewardedAd?.dispose();
    _anchoredBanner?.dispose();
    _nativeAd?.dispose();
  }

  void _cropScreen(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CropScreen(path: imagePath)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 105.0),
                    child: Text('Gallery', style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
            Row(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 35, top: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green.shade700),
                  ),
                  onPressed: () async {
                    final pickedFile =
                    await picker.getImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      File? croppedFile = await ImageCropper.cropImage(
                        sourcePath: pickedFile.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        androidUiSettings: AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.green[700],
                          toolbarWidgetColor: Colors.white,
                          activeControlsWidgetColor: Colors.green[700],
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false,
                        ),
                        iosUiSettings: IOSUiSettings(
                          minimumAspectRatio: 1.0,
                        ),
                      );

                      if (croppedFile != null) {
                        setState(() {
                          imagePath = croppedFile.path;
                        });
                      }
                      _cropScreen(context);
                    }
                  },
                  child: Text("Select Image"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50, top: 5),
                //width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green.shade700),
                  ),
                  onPressed: () async {
                    final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      File? croppedFile = await ImageCropper.cropImage(
                        sourcePath: pickedFile.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        androidUiSettings: AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.green[700],
                          toolbarWidgetColor: Colors.white,
                          activeControlsWidgetColor: Colors.green[700],
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false,
                        ),
                        iosUiSettings: IOSUiSettings(
                          minimumAspectRatio: 1.0,
                        ),
                      );
                      if (croppedFile != null) {
                        setState(() {
                          imagePath = croppedFile.path;
                        });
                      }
                      _cropScreen(context);
                    }
                  },
                  child: Text("Select Image"),
                ),
              ),
            ]),

            if(_nativeAdIsLoaded && _nativeAd!=null)
              Container(
                child: AdWidget(ad: _nativeAd!),
                width: 200,
                height: 20.0,
                padding: EdgeInsets.only(left:5, right:5),
                margin: EdgeInsets.only(top:130),
                alignment: Alignment.center,

              ),


            if (_anchoredBanner != null)
              Container(
                child: AdWidget(ad: _anchoredBanner!),
                width: _anchoredBanner!.size.width.toDouble(),
                height: 100.0,
                padding: EdgeInsets.only(left:5, right:5),
                margin: EdgeInsets.only(top:250),
                alignment: Alignment.center,
              ),
          ],
        ),
      ),
    );
  }
}
