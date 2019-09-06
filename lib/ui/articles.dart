import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_app/ui/articleDetail.dart';
import 'package:news_app/ui/login.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> with SingleTickerProviderStateMixin {
  List trendingNews = [];
  List entertainmentNews = [];
  List techNews = [];
  List sportsNews = [];
  // List generalNews = [];
  List scienceNews = [];
  List businessNews = [];
  List healthNews = [];
  FirebaseUser currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  // **** Swipe to refresh ****
  // final GlobalKey<RefreshIndicatorState> _refreshKey1 =
  //     GlobalKey<RefreshIndicatorState>();
  // final GlobalKey<RefreshIndicatorState> _refreshKey2 =
  //     GlobalKey<RefreshIndicatorState>();

// **** Calling top headlines or trending from newsapi ****
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
  // **** Calling Entertainment from newsapi ****

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

  @override
  void initState() {
    super.initState();
// Check the internet connectivity
    this.checkDataConnectivity();
    // **** invoking both api calls when the app started to build ****
    isLoading = true;
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

    // **** Refresh automatically when the app launches ****.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _refreshKey1.currentState.show();
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _refreshKey2.currentState.show();
    // });
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

  Future<void> checkDataConnectivity() async {
    // **** Check the connectivity ****
    var result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print("Connected");
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              semanticLabel: "No Internet Dialog",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              content: Image.asset("images/no_internet.gif"),
              title: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "No Internet",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });

      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    // **** Default Tab controller ****
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
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
            isScrollable: true,
            indicatorColor: Colors.white70,
            indicatorPadding: const EdgeInsets.all(2.0),
            // **** The size of the indicator is same as the size of the text ****
            // indicatorSize: TabBarIndicatorSize.label,
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
            // **** Showing loading Indicator ****
            Center(
              child: CircularProgressIndicator(),
            ),

            // **** Building TabBarView for showing the news in the body ****
            TabBarView(
              children: <Widget>[
                // **** Building list of trending news from news[] list ****
                // **** RefreshIndicator is used to implement the functionality of Swipe down to refresh it requires a GlobalKey and onRefresh callback ****
                // RefreshIndicator(
                // key: _refreshKey1,
                // onRefresh: _refresh1,
                ListView.builder(
                  itemCount: trendingNews == null ? 0 : trendingNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                    tag: trendingNews[i]['title'],
                                    // **** FadeinImage is used to get more UX ****
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/loading.gif',
                                      image:
                                          trendingNews[i]['urlToImage'] == null
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
                                          : trendingNews[i]['title'].toString(),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: FlatButton(
                                    splashColor: Colors.grey,
                                    onPressed: () {
                                      // **** Navigate the user to articleDetail page when the button is pressed along with passing the data by using constructor methods.
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

                // // Building list of allnews from allnews[] list
                // RefreshIndicator(
                //   key: _refreshKey2,
                //   onRefresh: _refresh2,
                ListView.builder(
                  itemCount:
                      entertainmentNews == null ? 0 : entertainmentNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                    tag: entertainmentNews[i]['title'],
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/loading.gif',
                                      image: entertainmentNews[i]
                                                  ['urlToImage'] ==
                                              null
                                          ? Image.asset(
                                              'images/imgPlaceholder.png',
                                            ).toString()
                                          : entertainmentNews[i]['urlToImage'],
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: FlatButton(
                                    splashColor: Colors.black,
                                    // color: Colors.black54,
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
                // Techonology news
                ListView.builder(
                  itemCount: techNews == null ? 0 : techNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
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
                ListView.builder(
                  itemCount: scienceNews == null ? 0 : scienceNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                          : scienceNews[i]['title'].toString(),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
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

                ListView.builder(
                  itemCount: sportsNews == null ? 0 : sportsNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                    tag: sportsNews[i]['title'],
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/loading.gif',
                                      image: sportsNews[i]['urlToImage'] == null
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
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

                ListView.builder(
                  itemCount: healthNews == null ? 0 : healthNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                    tag: healthNews[i]['title'],
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/loading.gif',
                                      image: healthNews[i]['urlToImage'] == null
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
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

                ListView.builder(
                  itemCount: businessNews == null ? 0 : businessNews.length,
                  itemBuilder: (_, int i) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                    tag: businessNews[i]['title'],
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/loading.gif',
                                      image:
                                          businessNews[i]['urlToImage'] == null
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
                                          : businessNews[i]['title'].toString(),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

// **** calling the refresh callback when swipe down ****
  // Future<void> _refresh1() async {
  //   print("Refrshing");
  //   // **** from getData() function then refresh it *****
  //   await getData().then((data) {
  //     setState(() {
  //       news = data as List;
  //     });
  //   });
  // }

  // Future<void> _refresh2() async {
  //   print("Refrshing");
  //   // **** from getData() function then refresh it *****
  //   await getAllData().then((data) {
  //     setState(() {
  //       allnews = data as List;
  //     });
  //   });
  // }
}
