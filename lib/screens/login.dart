import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/firebaseDb/googleSignIn.dart';
import 'package:news_app/services/usermanagement.dart';
import 'package:news_app/ui/articles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

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
  SharedPreferences preferences;

  // bool loading = false;
  bool isLogedin = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
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
    // Checking if the user is already signedin or not if signed in then directly return him to homescreen else he/she will be authenticated(should be signin first)
    this.isSignedIn();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void isSignedIn() async {
    await firebaseAuth.currentUser().then((user) {
      if (user != null) {
        setState(() => isLogedin = true);
      }
    });
    if (isLogedin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AllNews()));
    }
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
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
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
                  user.sendEmailVerification().then((val) {
                    _showCofirmDialog();
                  });
                  userManagement.createUser(user.uid.toString(), {
                    "userName": user.displayName,
                    "email": user.email,
                    "photoUrl": user.photoUrl,
                    "userId": user.uid,
                  });
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AllNews()));
                } else if (currentUser != null) {
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

  Future _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog("No Internet",
          "You are offline.Please check your internet connection.");
    }
    // } else if (result == ConnectivityResult.mobile) {
    //   _showDialog("Internet access", "You're connected over mobile data");
    // } else if (result == ConnectivityResult.wifi) {
    //   _showDialog('Internet access', "You're connected over wifi");
    // }
  }

  _showDialog(title, text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Card(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: ListTile(
              title: Text(
                title,
                style: Theme.of(context).textTheme.headline,
              ),
              leading: Icon(
                Icons.signal_cellular_connected_no_internet_4_bar,
                size: 30.0,
                color: Colors.red,
              ),
            ),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  _showCofirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Verify Your Email."),
          content: Text(
              "Confirmation email has been sent to your email id please verify."),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
