import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'savedArticles.dart';
import 'package:intl/intl.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> with SingleTickerProviderStateMixin {
  List news = [];
  List allnews = [];
  // bool _active = true;
  List savedArticles = [];
  bool _themeSwitch = false;

// Calling top headlines or trending from newsapi
  Future<String> getData() async {
    String url1 =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url1), headers: {"Accept": "application/json"});
    setState(() {
      var jsondata = json.decode(response.body);
      news = jsondata['articles'];
    });
    return "Success";
  }
  // Calling all news from newsapi

  Future<String> getAllData() async {
    String url2 =
        "https://newsapi.org/v2/everything?domains=wsj.com,nytimes.com&language=en&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url2), headers: {"Accept": "application/json"});
    setState(() {
      var alljsondata = json.decode(response.body);
      allnews = alljsondata['articles'];
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    // invoking both api calls when the app started to build
    this.getData();
    this.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          elevation: 1.7,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Ramu"),
                accountEmail: Text("ramubugudi4@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  child: Text(
                    "R",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                title: Container(
                  child: Text("Dark Theme"),
                ),
                trailing: Switch(
                  value: _themeSwitch,
                  onChanged: (val) {
                    setState(() {
                      _themeSwitch = val;
                    });
                    _toggleTheme();
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Container(
                  child: Text("Trending"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("All"),
                ),
              ),
            ],
          ),
          title: Text("BuzzyFeed"),
          centerTitle: true,
          elevation: 0,
        ),
        body: TabBarView(
          children: <Widget>[
            // Building list of trending news from news[] list
            ListView.builder(
              itemCount: news == null
                  ? Center(
                      child: Text(
                        "Loading!",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : news.length,
              itemBuilder: (_, int i) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // elevation: 2.0,
                        child: ListTile(
                          onTap: () {
                            debugPrint("Hello");
                          },
                          title: Container(
                            child: Stack(
                              alignment: AlignmentDirectional(0, 1),
                              // fit: StackFit.loose,
                              // overflow: Overflow.visible,
                              children: <Widget>[
                                Image.network(
                                  news[i]['urlToImage'] == null
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        ).toString()
                                      : news[i]['urlToImage'].toString(),
                                  colorBlendMode: BlendMode.darken,
                                  color: Colors.black38,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    news[i]['title'] == null
                                        ? Text("Title here").toString()
                                        : news[i]['title'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(""),
                                // child: IconButton(
                                //   color:
                                //       _active ? Colors.white : Colors.red[500],
                                //   icon: (_active
                                //       ? Icon(Icons.star_border)
                                //       : Icon(Icons.star)),
                                //   onPressed: () => _toggleActive(),
                                // ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: FlatButton(
                                  splashColor: Colors.black,
                                  // color: Colors.black54,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SavedArticles(
                                                  articles: news[i] == null
                                                      ? Text("Loading!")
                                                      : news[i],
                                                )));
                                  },
                                  child: Text(
                                    "Read More",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        letterSpacing: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(),
                  ],
                );
              },
            ),

            // // Building list of all news from allnews[] list
            ListView.builder(
              itemCount: allnews == null ? "Loading" : allnews.length,
              itemBuilder: (_, int i) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // elevation: 2.0,
                        child: ListTile(
                          onTap: () {
                            debugPrint("Hello");
                          },
                          title: Container(
                            child: Stack(
                              alignment: AlignmentDirectional(0, 1),
                              // fit: StackFit.loose,
                              // overflow: Overflow.visible,
                              children: <Widget>[
                                Image.network(
                                  allnews[i]['urlToImage'] == null
                                      ? Text("Image Here").toString()
                                      : allnews[i]['urlToImage'].toString(),
                                  colorBlendMode: BlendMode.darken,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    allnews[i]['title'].toString() == null
                                        ? Text("Title of the Article here!")
                                        : allnews[i]['title'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                // child: IconButton(
                                //   color:
                                //       _active ? Colors.white : Colors.red[500],
                                //   icon: (_active
                                //       ? Icon(Icons.star_border)
                                //       : Icon(Icons.star)),
                                //   onPressed: () => _toggleActive(),
                                // ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: FlatButton(
                                  // color: Colors.redAccent,
                                  splashColor: Colors.grey,
                                  onPressed: () {
                                    // setState(() {
                                    //   news.map((f) {
                                    //     savedArticles.add(news[f]);
                                    //   });
                                    // });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SavedArticles(
                                                  articles: allnews[i] == null
                                                      ? "Loading"
                                                      : allnews[i],
                                                )));
                                  },
                                  child: Text(
                                    "Read More",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        letterSpacing: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container()
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // void _toggleActive() {
  //   setState(() {
  //     if (_active) {
  //       _active = false;
  //     } else {
  //       _active = true;
  //     }
  //   });
  // }

  _toggleTheme() {
    return ThemeData(
      brightness: Brightness.light,
    );
  }
}
