// Imports

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_app/ui/articleDetail.dart';
import 'package:news_app/ui/login.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> with SingleTickerProviderStateMixin {
  // List of of that each tab contains:
  List trendingNews = [];
  List entertainmentNews = [];
  List techNews = [];
  List scienceNews = [];
  List sportsNews = [];
  List healthNews = [];
  // List generalNews = [];
  List businessNews = [];
  // Variables
  FirebaseUser currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  //  Keys to implement Swipe to refresh
  final GlobalKey<RefreshIndicatorState> _trendingTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _entertainmentTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _techTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _scienceTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _sportsTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _healthTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _businessTabRefreshKey =
      GlobalKey<RefreshIndicatorState>();

//  Calling trending news from newsapi.org
  Future<String> getTrendingData() async {
    String url1 =
        "https://newsapi.org/v2/top-headlines?country=in&pagesize=100&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url1), headers: {"Accept": "application/json"});
    setState(() {
      var trendingJsonData = json.decode(response.body);
      trendingNews = trendingJsonData['articles'];
    });
    return "Success";
  }
  //  Calling Entertainment news from newsapi.org

  Future<String> getEntertainmentData() async {
    String url2 =
        "https://newsapi.org/v2/top-headlines?country=in&category=entertainment&pagesize=100&language=en&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url2), headers: {"Accept": "application/json"});
    setState(() {
      var entertainmentJsonData = json.decode(response.body);
      entertainmentNews = entertainmentJsonData['articles'];
    });
    return "Success";
  }

// Calling Technology data from newsapi.org
  Future<void> getTechnologyData() async {
    String url3 =
        "https://newsapi.org/v2/top-headlines?country=in&category=technology&pagesize=100&language=te&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url3), headers: {"Accept": "application/json"});
    setState(() {
      var techJsonData = json.decode(response.body);
      techNews = techJsonData['articles'];
    });
    return "Success";
  }
// Calling Sports news from newsapi.org

  Future<void> getSportsData() async {
    String url4 =
        "https://newsapi.org/v2/top-headlines?country=in&category=sports&pagesize=100&language=en&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url4), headers: {"Accept": "application/json"});
    setState(() {
      var sportsJsonData = json.decode(response.body);
      sportsNews = sportsJsonData['articles'];
    });
    return "Success";
  }
// Calling Science news from newsapi.org

  Future<void> getScienceData() async {
    String url5 =
        "https://newsapi.org/v2/top-headlines?country=in&category=science&pagesize=100&language=en&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url5), headers: {"Accept": "application/json"});
    setState(() {
      var scienceJsonData = json.decode(response.body);
      scienceNews = scienceJsonData['articles'];
    });
    return "Success";
  }
// Calling Business news from newsapi.org

  Future<void> getBusinessData() async {
    String url6 =
        "https://newsapi.org/v2/top-headlines?country=in&category=business&pagesize=100&language=en&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url6), headers: {"Accept": "application/json"});
    setState(() {
      var businessJsonDat = json.decode(response.body);
      businessNews = businessJsonDat['articles'];
    });
    return "Success";
  }
// Calling Health news from newsapi.org

  Future<void> getHealthData() async {
    String url7 =
        "https://newsapi.org/v2/top-headlines?country=in&category=health&pagesize=100&language=en&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url7), headers: {"Accept": "application/json"});
    setState(() {
      var healthJsonData = json.decode(response.body);
      healthNews = healthJsonData['articles'];
    });
    return "Success";
  }
  // InitState

  @override
  void initState() {
    super.initState();
    // Check the internet connectivity
    this.checkDataConnectivity();
    //  invoking api calls when the app started to build ****
    this.getTrendingData();
    this.getEntertainmentData();
    this.getTechnologyData();
    this.getSportsData();
    this.getScienceData();
    this.getBusinessData();
    this.getHealthData();
    // **** Loading current user details ****
    _loadCurrentUser();
    //Dynamic link

    this.initDynamicLinks();

    //  Refresh automatically when the app launches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trendingTabRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entertainmentTabRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _techTabRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scienceTabRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sportsTabRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _healthTabRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _businessTabRefreshKey.currentState.show();
    });
  }

// Dynamic link
  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    print(deepLink);
    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('OnLinkError');
      print(e.message);
    });
  }
  // Loading the current user data

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

// Connectivity checker function
  Future<void> checkDataConnectivity() async {
    // **** Check the connectivity ****
    var result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print("Connected");
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "No Internet",
        desc:
            "You are Offline.No Internet Conncection Please Connect To A Network!",
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          titleStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w900,
            fontSize: 30.0,
          ),
          descStyle: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        buttons: [
          DialogButton(
              color: Colors.grey,
              child: Text(
                "OK",
                style: TextStyle(fontSize: 20),
              ),
              width: 120,
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ).show();
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Default Tab controller
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black26),
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
                  //  Signing out the user popping the screen and navigate the user to login page
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
                    color: Colors.white,
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

          //  Tabbar in appbar
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white70,
            indicatorPadding: const EdgeInsets.all(2.0),
            //  The size of the indicator is same as the size of the text
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
                  child: Text("Cinema"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("Technology"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("Science"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("Sports"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("Health"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("Business"),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            //  Building TabBarView for showing the news in the body
            TabBarView(
              children: <Widget>[
                //  RefreshIndicator is used to implement the functionality of Swipe down to refresh it requires a GlobalKey and onRefresh callback

                RefreshIndicator(
                  key: _trendingTabRefreshKey,
                  onRefresh: _refreshTrendingTab,
                  // Listview builder to return the trending news from newsapi.org
                  child: ListView.builder(
                    itemCount: trendingNews == null ? 0 : trendingNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: trendingNews[i] == null
                                          ? Text("Loading!")
                                          : trendingNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  //   AlignmentDirectional is used to place the text whereever we wanted on the image
                                  alignment: AlignmentDirectional(0, 0.9),

                                  children: <Widget>[
                                    //  Hero animation
                                    Hero(
                                      tag: trendingNews[i]['title'],
                                      //  FadeinImage is used to get more UX
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image: trendingNews[i]['urlToImage'] ==
                                                null
                                            ? Image.asset(
                                                'images/imgPlaceholder.png',
                                              ).toString()
                                            : trendingNews[i]['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        trendingNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : trendingNews[i]['title']
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w300,
                                          backgroundColor: Colors.black26,
                                        ),
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
                                        //  Navigate the user to articleDetail page when the button is pressed along with passing the data by using constructor methods.
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ArticleDetail(
                                              articles: trendingNews[i] == null
                                                  ? Text("Loading!")
                                                  : trendingNews[i],
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
                          Container(),
                        ],
                      );
                    },
                  ),
                ),
                // Listview builder to return the entertainment news from newsapi.org

                RefreshIndicator(
                  key: _entertainmentTabRefreshKey,
                  onRefresh: _refreshEntertainmentTab,
                  child: ListView.builder(
                    itemCount: entertainmentNews == null
                        ? 0
                        : entertainmentNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("ListTile tapped!");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: entertainmentNews[i] == null
                                          ? Text("Loading!")
                                          : entertainmentNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: entertainmentNews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image: entertainmentNews[i]
                                                    ['urlToImage'] ==
                                                null
                                            ? Image.asset(
                                                'images/imgPlaceholder.png',
                                              ).toString()
                                            : entertainmentNews[i]
                                                ['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        entertainmentNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : entertainmentNews[i]['title']
                                                .toString(),
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
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ArticleDetail(
                                              articles:
                                                  entertainmentNews[i] == null
                                                      ? Text("Loading!")
                                                      : entertainmentNews[i],
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
                          Container(),
                        ],
                      );
                    },
                  ),
                ),
                // Listview builder to return the Techonology news from newsapi.org

                RefreshIndicator(
                  key: _techTabRefreshKey,
                  onRefresh: _refreshTechTab,
                  child: ListView.builder(
                    itemCount: techNews == null ? 0 : techNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: techNews[i] == null
                                          ? Text("Loading!")
                                          : techNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: techNews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image: techNews[i]['urlToImage'] == null
                                            ? Image.asset(
                                                'images/imgPlaceholder.png',
                                              ).toString()
                                            : techNews[i]['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        techNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : techNews[i]['title'].toString(),
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
                                              articles: techNews[i] == null
                                                  ? Text("Loading!")
                                                  : techNews[i],
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
                          // Container(),
                          Container(),
                        ],
                      );
                    },
                  ),
                ),
                // Listview builder to return the Science news from newsapi.org

                RefreshIndicator(
                  key: _scienceTabRefreshKey,
                  onRefresh: _refreshScienceTab,
                  child: ListView.builder(
                    itemCount: scienceNews == null ? 0 : scienceNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            // color: Colors.blueGrey,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: scienceNews[i] == null
                                          ? Text("Loading!")
                                          : scienceNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: scienceNews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image:
                                            scienceNews[i]['urlToImage'] == null
                                                ? Image.asset(
                                                    'images/imgPlaceholder.png',
                                                  ).toString()
                                                : scienceNews[i]['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        scienceNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : scienceNews[i]['title']
                                                .toString(),
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
                                              articles: scienceNews[i] == null
                                                  ? Text("Loading!")
                                                  : scienceNews[i],
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
                          // Container(),
                          Container(),
                        ],
                      );
                    },
                  ),
                ),

                // Listview builder to return the Sports news from newsapi.org

                RefreshIndicator(
                  key: _sportsTabRefreshKey,
                  onRefresh: _refreshSportsTab,
                  child: ListView.builder(
                    itemCount: sportsNews == null ? 0 : sportsNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            // color: Colors.blueGrey,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: sportsNews[i] == null
                                          ? Text("Loading!")
                                          : sportsNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: sportsNews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image:
                                            sportsNews[i]['urlToImage'] == null
                                                ? Image.asset(
                                                    'images/imgPlaceholder.png',
                                                  ).toString()
                                                : sportsNews[i]['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        sportsNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : sportsNews[i]['title'].toString(),
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
                                              articles: sportsNews[i] == null
                                                  ? Text("Loading!")
                                                  : sportsNews[i],
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
                          // Container(),
                          Container(),
                        ],
                      );
                    },
                  ),
                ),

                // Listview builder to return the Health news from newsapi.org

                RefreshIndicator(
                  key: _healthTabRefreshKey,
                  onRefresh: _refreshHealthTab,
                  child: ListView.builder(
                    itemCount: healthNews == null ? 0 : healthNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            // color: Colors.blueGrey,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: healthNews[i] == null
                                          ? Text("Loading!")
                                          : healthNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: healthNews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image:
                                            healthNews[i]['urlToImage'] == null
                                                ? Image.asset(
                                                    'images/imgPlaceholder.png',
                                                  ).toString()
                                                : healthNews[i]['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        healthNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : healthNews[i]['title'].toString(),
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
                                              articles: healthNews[i] == null
                                                  ? Text("Loading!")
                                                  : healthNews[i],
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
                          // Container(),
                          Container(),
                        ],
                      );
                    },
                  ),
                ),

                // Listview builder to return the Business news from newsapi.org

                RefreshIndicator(
                  key: _businessTabRefreshKey,
                  onRefresh: _refreshBusinessTab,
                  child: ListView.builder(
                    itemCount: businessNews == null ? 0 : businessNews.length,
                    itemBuilder: (_, int i) {
                      return Column(
                        children: <Widget>[
                          Card(
                            // color: Colors.blueGrey,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint("Hello");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetail(
                                      articles: businessNews[i] == null
                                          ? Text("Loading!")
                                          : businessNews[i],
                                    ),
                                  ),
                                );
                              },
                              title: Container(
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: <Widget>[
                                    Hero(
                                      tag: businessNews[i]['title'],
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/loading.gif',
                                        image: businessNews[i]['urlToImage'] ==
                                                null
                                            ? Image.asset(
                                                'images/imgPlaceholder.png',
                                              ).toString()
                                            : businessNews[i]['urlToImage'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        businessNews[i]['title'] == null
                                            ? Text("Title here").toString()
                                            : businessNews[i]['title']
                                                .toString(),
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
                                              articles: businessNews[i] == null
                                                  ? Text("Loading!")
                                                  : businessNews[i],
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
                          // Container(),
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

//  calling the refresh callback when swipe down
  Future _refreshTrendingTab() async {
    print("Refrshing");
    // **** from getData() function then refresh it *****
    // await getTrendingData().then((data) {
    //   setState(() {
    //     trendingNews = data as List;
    //   });
    // });
    await getTrendingData();
    setState(() {});
  }

  Future _refreshEntertainmentTab() async {
    print("Refrshing");

    await getEntertainmentData();
    setState(() {});
  }

  Future _refreshTechTab() async {
    print("Refrshing");

    await getTechnologyData();
    setState(() {});
  }

  Future _refreshScienceTab() async {
    print("Refrshing");

    await getScienceData();
    setState(() {});
  }

  Future _refreshSportsTab() async {
    print("Refrshing");

    await getSportsData();
    setState(() {});
  }

  Future _refreshHealthTab() async {
    print("Refrshing");

    await getHealthData();
    setState(() {});
  }

  Future _refreshBusinessTab() async {
    print("Refrshing");

    await getBusinessData();
    setState(() {});
  }
}
