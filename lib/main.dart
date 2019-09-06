import 'package:flutter/material.dart';
import 'package:news_app/ui/login.dart';

void main() async {
  runApp(
    MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      title: "Buzzyfeed",
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: "Montserrat",
          textTheme: TextTheme(
            headline: TextStyle(fontWeight: FontWeight.w900, fontSize: 25.0),
            body2: TextStyle(fontStyle: FontStyle.italic),
            subhead: TextStyle(fontWeight: FontWeight.bold),
          )),
    ),
  );
}

//Android-X error
// For Android-X error use multiDexEnabled true in app(build.gradle) defaultConfig {}
// android.useAndroidX=true, android.enable Jetifier=true in gradle.properties
