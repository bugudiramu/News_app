import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/services/googleSignIn.dart';
import 'package:news_app/services/usermanagement.dart';
import 'package:news_app/ui/articles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  // **** Auth class from googleSignIn.dart ****
  Auth _auth = Auth();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement userManagement = UserManagement();
  FirebaseUser currentUser;
  // **** SharedPreferences is used to store local data that when the user wants to launch the app again it won't show splash screen or starter notes again. ****
  SharedPreferences preferences;

  // bool loading = false;
  bool isLogedin = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // **** Check whether the device is connected to any network or not ****
    _checkDataConnectivity();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
          curve: Interval(0.0, 0.5, curve: Curves.bounceInOut),
          parent: controller),
    );

    controller.forward();
    // Checking if the user is already signedin or not if signed in then directly return him to homescreen else he/she will be authenticated(should be signin first)
    this.isSignedIn();
  }

  @override
  void dispose() {
    // **** Cancelling all the resources of animation ****
    controller.dispose();
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
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: Container(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Image.asset(
                    "images/icon/launcherIcon.png",
                    // **** Resizing the image as per the animation value ****
                    height: 100.0,
                    width: 100.0,
                  ),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  //   child: Text(
                  //     "Welcome to BuzzyFeed.From now I hope you will never miss any update.",
                  //     style: TextStyle(),
                  //   ),
                  // ),

                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        color: Colors.purpleAccent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: Text(
                            "Sign In With Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
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
                            // Send email verification
                            // user.sendEmailVerification().then((val) {
                            //   _showCofirmDialog();
                            // });
                            // **** Create the user in Firebase Realtime Database by using UserManagemet class ****
                            userManagement.createUser(user.uid.toString(), {
                              "userName": user.displayName,
                              "email": user.email,
                              "photoUrl": user.photoUrl,
                              "userId": user.uid,
                            });

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AllNews()));
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _checkDataConnectivity() async {
    // **** Check the connectivity ****
    var result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print("COnnected");
    } else {
      // **** Showing confirmation dialog ****
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("No Internet Please Connect To Network!"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                )
              ],
            );
          });
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
    }
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