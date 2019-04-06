import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utils/utils.dart' as utils;

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> with SingleTickerProviderStateMixin {
  TabController _tabController;
  void getResponse() async {
    Map _data = await getData(utils.apiKey);
    debugPrint("$_data");
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text("Latest"),
            ),
            Tab(
              child: Text("Feed"),
            )
          ],
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Center(child: Text("Latest")),
            Center(child: Text("Feed")),
          ],
        ),
      ),
    );
  }
}

Future<Map> getData(String apiKey) async {
  String apiUrl =
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey";
  http.Response response = await http.get(apiUrl);
  debugPrint('Response stauts: ${response.statusCode}');

  return json.decode(response.body);
}
