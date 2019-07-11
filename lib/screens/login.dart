import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/firebaseDb/googleSignIn.dart';
import 'package:news_app/services/usermanagement.dart';
import 'package:news_app/ui/articles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;
  Tween _tween;
  Auth _auth = Auth();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement userManagement = UserManagement();
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
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
    _controller.dispose();
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
                  fontSize: _animation.value - 84,
                ),
              ),
            ),
            SizedBox(
              height: _animation.value,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.purpleAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                child: Text(
                  "Sign In With Google",
                  style: TextStyle(
                      color: Colors.white, fontSize: _animation.value - 78),
                ),
              ),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        content: Row(
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text("Loading!")
                          ],
                        ),
                      );
                    });
                FirebaseUser user = await _auth.googleSignIn();
                if (user != null) {
                  userManagement.createUser(user.uid.toString(), {
                    "userName": user.displayName,
                    "email": user.email,
                    "photoUrl": user.photoUrl,
                    "userId": user.uid,
                  });
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AllNews()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
