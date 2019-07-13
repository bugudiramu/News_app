import 'package:flutter/material.dart';
import 'package:news_app/screens/login.dart';

void main() async {
  runApp(
    MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      title: "Buzzyfeed",
      theme: ThemeData(fontFamily: "Montserrat"),
    ),
  );
}

//Android-X error
// For Android-X error use multiDexEnabled true in app(build.gradle) defaultConfig {}
// android.useAndroidX=true, android.enable Jetifier=true in gradle.properties
