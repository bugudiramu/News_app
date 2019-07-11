import 'package:flutter/material.dart';
import 'package:news_app/ui/login.dart';

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
