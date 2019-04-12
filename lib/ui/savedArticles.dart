import 'package:flutter/material.dart';
// import 'allnews.dart';

class SavedArticles extends StatefulWidget {
  final articles;
  final like;
  SavedArticles({this.articles, this.like});
  @override
  _SavedArticlesState createState() => _SavedArticlesState();
}

class _SavedArticlesState extends State<SavedArticles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Articles"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.only(top: 20.0),
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  "${widget.articles['title'] == null ? 'Loading' : widget.articles['title'].toString()}",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        "${widget.articles['publishedAt'] == null ? 'Loading' : widget.articles['publishedAt'].toString()}"),
                    Text("Share")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
                child: Image.network(
                  widget.articles['urlToImage'] == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        ).toString()
                      : widget.articles['urlToImage'].toString(),
                  filterQuality: FilterQuality.low,
                  scale: 1.0,
                ),
                alignment: Alignment.center,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Written by :"),
                    Text(
                      "${widget.articles['author'] == null ? 'Ananymous Author' : widget.articles['author'].toString()}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 18.0,
                          letterSpacing: 0.4),
                    )
                  ],
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Text(
                      "${widget.articles['description'] == null ? 'Description of Article' : widget.articles['description'].toString()}",
                      style: TextStyle(fontSize: 16.0, color: Colors.white54))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                child: Text(
                  "${widget.articles['content'] == null ? 'Loading' : widget.articles['content'].toString()}",
                  style: TextStyle(),
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("For More Info Visit following URL :"),
                      ),
                      Text(
                        "${widget.articles['url'] == null ? 'Loading' : widget.articles['url'].toString()}",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
// Center(
//   child: Text(widget.articles['author'].toString()),
// )
