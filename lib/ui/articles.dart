import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:news_app/articleDetail.dart';
import 'dart:convert';

import 'package:news_app/screens/login.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> with SingleTickerProviderStateMixin {
  List news = [];
  List allnews = [];
  List savedArticles = [];
  int counter = 0;
  FirebaseUser currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // bool _darkmode = false;

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
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
      });
    });
  }

  String username() {
    if (currentUser != null) {
      return currentUser.displayName;
    } else {
      return "no user name";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no email";
    }
  }

  String photoUrl() {
    if (currentUser != null) {
      return currentUser.photoUrl;
    } else {
      return "no photo";
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // For DarkMode
        // theme: _darkmode ? ThemeData.dark() : ThemeData.light(),
        DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          elevation: 1.7,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey),
                accountName: Text("${username()}"),
                accountEmail: Text("${email()}"),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: FadeInImage.assetNetwork(
                      image: photoUrl(),
                      placeholder: "images/icon/launcherIcon.png",
                    )),
              ),
              // Dark Mode
              // ListTile(
              //   title: Text("DarkMode"),
              //   trailing: Switch(
              //     value: _darkmode,
              //     onChanged: (val) {
              //       setState(() {
              //         _darkmode = val;
              //       });
              //     },
              //   ),
              // ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                firebaseAuth.signOut().then((user) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()));
                });
              },
            ),
          ],
          backgroundColor: Colors.blueGrey,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorPadding: const EdgeInsets.all(2.0),
            indicatorSize: TabBarIndicatorSize.label,
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
        body: Stack(
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
            TabBarView(
              children: <Widget>[
                // Building list of trending news from news[] list
                ListView.builder(
                  itemCount: news == null ? 0 : news.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: news[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image: news[i]['urlToImage'] == null
                                            ? AssetImage(
                                                    'images/imgPlaceholder.png')
                                                .toString()
                                            : news[i]['urlToImage'],
                                      ),
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
                                            fontSize: 16.0,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: FlatButton(
                                      splashColor: Colors.black,
                                      // color: Colors.black54,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ArticleDetail(
                                                  articles: news[i] == null
                                                      ? Text("Loading!")
                                                      : news[i],
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Read More",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18.0,
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

                // // Building list of allnews from allnews[] list
                ListView.builder(
                  itemCount: allnews == null ? 0 : allnews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: allnews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                          placeholder: 'images/loading.gif',
                                          image: allnews[i]['urlToImage'] ==
                                                  null
                                              ? AssetImage(
                                                      'images/imgPlaceholder.png')
                                                  .toString()
                                              : allnews[i]['urlToImage']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        allnews[i]['title'] == null
                                            ? Text("Title here").toString()
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: FlatButton(
                                      splashColor: Colors.black,
                                      // color: Colors.black54,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ArticleDetail(
                                                  articles: news[i] == null
                                                      ? Text("Loading!")
                                                      : allnews[i],
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Read More",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
