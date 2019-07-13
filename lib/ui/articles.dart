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
  FirebaseUser currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // **** Swipe to refresh ****
  final GlobalKey<RefreshIndicatorState> _refreshKey1 =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey2 =
      GlobalKey<RefreshIndicatorState>();

// **** Calling top headlines or trending from newsapi ****
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
  // **** Calling allnews from newsapi ****

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
    // **** invoking both api calls when the app started to build ****
    this.getData();
    this.getAllData();
    // **** Loading current user details ****
    _loadCurrentUser();

    // **** Refresh automatically when the app launches ****.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _refreshKey1.currentState.show();
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _refreshKey2.currentState.show();
    // });
  }

  void _loadCurrentUser() async {
    // Setting the current user details to currentuser object
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
      return "Guest User";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "guestuser@gmail.com";
    }
  }

  String photoUrl() {
    if (currentUser != null) {
      return currentUser.photoUrl;
    } else {
      return "G";
    }
  }

  @override
  Widget build(BuildContext context) {
    // **** Default Tab controller ****
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey),
                // **** calling username() funtion and others aswell ****
                accountName: Text("${username()}"),
                accountEmail: Text("${email()}"),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: FadeInImage.assetNetwork(
                      image: photoUrl(),
                      placeholder: "images/icon/launcherIcon.png",
                    )),
              ),
              InkWell(
                onTap: () async {
                  // **** Signing out the user popping the screen and navigate the user to login page ****
                  await firebaseAuth.signOut().then((user) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  });
                },
                child: ListTile(
                  leading: Image.asset(
                    "images/logout.png",
                    height: 20.0,
                  ),
                  title: Text(
                    "LogOut",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("BuzzyFeed"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blueGrey,
          // **** Tabbar in appbar ****
          bottom: TabBar(
            indicatorColor: Colors.white70,
            indicatorPadding: const EdgeInsets.all(2.0),
            // **** The size of the indicator is same as the size of the text ****
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5.0,

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
        ),
        body: Stack(
          children: <Widget>[
            // **** Showing loading Indicator ****
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
            // **** Building TabBarView for showing the news in the body ****
            TabBarView(
              children: <Widget>[
                // **** Building list of trending news from news[] list ****
                // **** RefreshIndicator is used to implement the functionality of Swipe down to refresh it requires a GlobalKey and onRefresh callback ****
                RefreshIndicator(
                  key: _refreshKey1,
                  onRefresh: _refresh1,
                  child: ListView.builder(
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
                                  debugPrint("ListTile tapped!");
                                },
                                title: Container(
                                  child: Stack(
                                    // ****  AlignmentDirectional is used to place the text whereever we wanted on the image
                                    alignment: AlignmentDirectional(0, 1),
                                    children: <Widget>[
                                      // **** Hero animation ****
                                      Hero(
                                        tag: news[i]['title'],
                                        // **** FadeinImage is used to get more UX ****
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'images/loading.gif',
                                          image: news[i]['urlToImage'] == null
                                              ? Image.asset(
                                                  'images/imgPlaceholder.png',
                                                ).toString()
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
                                        splashColor: Colors.grey,
                                        onPressed: () {
                                          // **** Navigate the user to articleDetail page when the button is pressed along with passing the data by using constructor methods.
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
                ),

                // // Building list of allnews from allnews[] list
                RefreshIndicator(
                  key: _refreshKey2,
                  onRefresh: _refresh2,
                  child: ListView.builder(
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
                                          image:
                                              allnews[i]['urlToImage'] == null
                                                  ? Image.asset(
                                                      'images/imgPlaceholder.png',
                                                    ).toString()
                                                  : allnews[i]['urlToImage'],
                                        ),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// **** calling the refresh callback when swipe down ****
  Future _refresh1() async {
    print("Refrshing");
    // **** from getData() function then refresh it *****
    await getData().then((data) {
      setState(() {
        news = data as List;
      });
    });
  }

  Future _refresh2() async {
    print("Refrshing");
    // **** from getData() function then refresh it *****
    await getAllData().then((data) {
      setState(() {
        allnews = data as List;
      });
    });
  }
}
