import 'package:flutter/material.dart';
import 'ui/allnews.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AllNews(),
    theme: ThemeData(
platform: TargetPlatform.android,      // primaryColor: Colors.blue,
      // primarySwatch: Colors.black,
      brightness: Brightness.dark
    ),
  ));
}
