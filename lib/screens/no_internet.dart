import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/no_internet.gif"),
            Container(
              child: Text(
                "You are offine",
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                "Please check your connection and try agian!",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
