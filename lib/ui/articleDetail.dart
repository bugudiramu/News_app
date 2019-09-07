import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class ArticleDetail extends StatefulWidget {
  final articles;
  ArticleDetail({this.articles});
  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  // Dynamic Link
  final myUrl = "https://buzzyfeed.page.link/AJDA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("BuzzyFeed"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 5.0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            //Back arrow
            // Container(
            //   alignment: Alignment.topLeft,
            //   child: IconButton(
            //     icon: Icon(Icons.arrow_back),
            //     onPressed: () => Navigator.of(context).pop(),
            //   ),
            // ),
            // Image
            Container(
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: widget.articles['title'],
                    child: FadeInImage.assetNetwork(
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      height: 280.0,
                      // width: MediaQuery.of(context).size.width,
                      placeholder: 'images/loading.gif',
                      image: widget.articles['urlToImage'] == null
                          ? Image.asset(
                              'images/imgPlaceholder.png',
                            ).toString()
                          : widget.articles['urlToImage'],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            // Title
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              child: Text(
                "${widget.articles['title'] == null ? 'Title Here' : widget.articles['title']}",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Divider(),

            // Author name
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Posted by : ",
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Expanded(
                    child: Text(
                      "${widget.articles['author'] == null ? 'Ananymous Author' : widget.articles['author'].toString()}",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                  // Share button
                  Container(
                    // alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(Icons.share),
                      iconSize: 30.0,
                      color: Colors.grey,
                      onPressed: () => Share.share(
                          "Click the link to read the article $myUrl"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
            ),
            Divider(),

// Description
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: Text(
                  "${widget.articles['description'] == null ? 'Description of Article' : widget.articles['description']}",
                  style: Theme.of(context).textTheme.subhead),
            ),
            Divider(),
            // Content
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: Text(
                "${widget.articles['content'] == null ? 'Loading' : widget.articles['content']}",
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            // Read the full article by clicking the URL
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "For More Info Visit following URL :",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      //  open the link in the default browser when link is clicked
                      if (await canLaunch(
                          "${widget.articles['url'] == null ? 'Loading' : widget.articles['url'].toString()}")) {
                        await launch("${widget.articles['url'].toString()}");
                      } else {
                        Exception("URL doesn't exist");
                      }
                    },
                    child: Text(
                      "Click here",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        debugLabel: "Link",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
