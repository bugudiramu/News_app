import 'package:flutter/material.dart';
import 'ui/allnews.dart';
import 'package:flutter/foundation.dart';

void main() async {
  runApp(
    MaterialApp(
      title: "BuzzyFeed",
      debugShowCheckedModeBanner: false,
      home: AllNews(),
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? ThemeData.light()
          : ThemeData.dark(),
    ),
  );
}
