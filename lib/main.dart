//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/view/splash_screen.dart';
//import 'dart:ui_web' as ui;
//import 'package:url_strategy/url_strategy.dart';
//import 'package:flutter_web_plugins/url_strategy.dart';
void main() {
  // if(kIsWeb){
  //   setUrlStrategy;
    runApp( const MyApp());

  }
  class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      home: SplashScreen(),
    );
  }
}
