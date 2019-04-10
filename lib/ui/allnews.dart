import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'savedArticles.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List news = [];
  bool _active = false;
  List savedArticles = [];

  Future<String> getData() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=31ca4832eab448daa762754f150bd3b8";
    http.Response response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      var jsondata = json.decode(response.body);
      news = jsondata['articles'];
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
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
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SavedArticles()));
              },
              title: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Saved Articles",
                  style: TextStyle(fontSize: 20.0, letterSpacing: 0.5),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: news == null
            ? Center(
                child: Text("Loading!"),
              )
            : news.length,
        itemBuilder: (_, int i) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2.0,
                  // color: Colors.lightGreenAccent,
                  child: ListTile(
                    title: Container(
                      child: Stack(
                        alignment: AlignmentDirectional(0, 1),
                        // fit: StackFit.loose,
                        overflow: Overflow.clip,
                        children: <Widget>[
                          Image.network(
                            news[i]['urlToImage'].toString(),
                            colorBlendMode: BlendMode.darken,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              news[i]['title'].toString(),
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
                          //   color: _active == true
                          //       ? Colors.white
                          //       : Colors.redAccent,
                          //   icon: (_active == false
                          //       ? Icon(Icons.thumb_down)
                          //       : Icon(Icons.thumb_up)),
                          //   onPressed: () {
                          //     setState(() {
                          //       _active = true;
                          //     });
                          //   },
                          // ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: FlatButton(
                            color: Colors.redAccent,
                            splashColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                savedArticles.add(news[i]);
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SavedArticles()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    letterSpacing: 1.8),
                              ),
                            ),
                          ),
                        ),
                        // Center(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text(
                        //       news[i]['author'].toString(),
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w900, fontSize: 20.0),
                        //     ),
                        //   ),
                        // ),
                        // Center(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text(
                        //       news[i]['description'].toString(),
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w400, fontSize: 17.0),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
              ),
            ],
          );
        },
      ),
    );
  }
}
