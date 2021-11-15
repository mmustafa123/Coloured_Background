import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0B00),
        scaffoldBackgroundColor: Color(0xFF0A0E61),
        //accentColor: Colors.deepPurple,
        //textTheme:  TextTheme(    body1: TextStyle(color:Colors.white) )
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      //home: Camera(),
    );
  }
}