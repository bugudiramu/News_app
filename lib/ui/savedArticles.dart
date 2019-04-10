import 'package:flutter/material.dart';

class SavedArticles extends StatefulWidget {

  @override
  _SavedArticlesState createState() => _SavedArticlesState();
}

class _SavedArticlesState extends State<SavedArticles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Saved Articles"),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[],
        ));
  }
}
