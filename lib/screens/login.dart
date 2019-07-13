import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/firebaseDb/googleSignIn.dart';
import 'package:news_app/screens/no_internet.dart';
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
  // **** Auth class from googleSignIn.dart ****
  Auth _auth = Auth();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement userManagement = UserManagement();
  FirebaseUser currentUser;
  // **** SharedPreferences is used to store local data that when the user wants to launch the app again it won't show splash screen or starter notes again. ****
  SharedPreferences preferences;

  // bool loading = false;
  bool isLogedin = false;

  @override
  void initState() {
    super.initState();
    // **** Check whether the device is connected to any network or not ****
    _checkConnectivity();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
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
    // **** Cancelling all the resources of animation ****
    _controller.dispose();
    super.dispose();
  }

  void isSignedIn() async {
    // **** check if user is already logged in or not if yes the set isLogedin value to true.
    await firebaseAuth.currentUser().then((user) {
      if (user != null) {
        setState(() => isLogedin = true);
      }
    });
    // **** if isLogedin is true then return the user to our Homescreen ****
    if (isLogedin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AllNews()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // **** Beautiful gradient background ****
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
              // **** Resizing the image as per the animation value ****
              height: _animation.value,
              width: _animation.value,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text(
                "Welcome to BuzzyFeed.From now I hope you will never miss any update.",
                style: TextStyle(
                  color: Colors.white,
                  // **** fontSize: 100 - 84 = 16 ****
                  fontSize: _animation.value - 84,
                ),
              ),
            ),
            SizedBox(
              height: _animation.value,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
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
                // **** Show Loading Indicator when button is pressed ****
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
                // **** We are checkng whether googleUser is empty or not if not empty then send Email Verification and show the dialog ****
                FirebaseUser user = await _auth.googleSignIn();

                if (user != null) {
                  user.sendEmailVerification().then((val) {
                    _showCofirmDialog();
                  });
                  // **** Create the user in Firebase Realtime Database by using UserManagemet class ****
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

  Future _checkConnectivity() async {
    // **** Check the connectivity ****
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NoInternet()));
    }
    //  else if (result == ConnectivityResult.mobile ||
    //     result == ConnectivityResult.wifi) {
    //   return Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) => AllNews()));
    // }
  }

  _showCofirmDialog() {
    // **** Showing confirmation dialog ****
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

// Dark Mode
  // bool _darkmode = false;

  // theme: _darkmode ? ThemeData.dark() : ThemeData.light(),

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