import 'package:flutter/material.dart';
import 'package:news_app/ui/login.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      title: "Buzzyfeed",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Montserrat",
        // Dynamic font styles
        textTheme: TextTheme(
          headline: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0),
          body2: TextStyle(fontStyle: FontStyle.italic),
          subhead: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

//Android-X error
// For Android-X error use multiDexEnabled true in app(build.gradle) defaultConfig {}
// android.useAndroidX=true, android.enable Jetifier=true in gradle.properties
