import 'package:flutter/material.dart';
import 'package:news_app/ui/articles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;
  Tween _tween;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _tween = Tween<double>(begin: 0.0, end: 100.0);
    _animation = _tween.animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.purpleAccent,
            ],
            begin: Alignment.topRight,
            tileMode: TileMode.mirror,
          ),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Image.asset(
              "images/icon/launcherIcon.png",
              height: _animation.value,
              width: _animation.value,
              // height: 100.0,
              // width: 80.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text(
                "Welcome to BuzzyFeed.From now I hope you will never miss any update.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                child: Text(
                  "Sign In With Google",
                  style: TextStyle(color: Colors.white, fontSize: 23.5),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AllNews()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
