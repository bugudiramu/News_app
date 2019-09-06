import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/services/googleSignIn.dart';
import 'package:news_app/services/usermanagement.dart';
import 'package:news_app/ui/articles.dart';
import 'package:random_color/random_color.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  Animation animation, delayAnimation, muchDelayedAnimation;
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

  @override
  void initState() {
    super.initState();

    // **** Check whether the device is connected to any network or not ****
    checkDataConnectivity();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2700),
    );
    animation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        parent: controller,
      ),
    );
    delayAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

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
    controller.forward();

    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/bg1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  RotationTransition(
                    turns: animation,
                    child: Image.asset(
                      "images/icon/launcherIcon.png",
                      // **** Resizing the image as per the animation value ****
                      height: 125.0,
                      width: 125.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        delayAnimation.value * width, 0.0, 0.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Text(
                          "Welcome to BuzzyFeed.From now I hope you will never miss any update.",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: MaterialButton(
                          color: Colors.pink.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            child: Text(
                              "Sign In With Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // **** Show Loading Indicator when button is pressed ****
                            checkDataConnectivity();
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    // backgroundColor: Colors.transparent,
                                    content: Row(
                                      children: <Widget>[
                                        CircularProgressIndicator(
                                          backgroundColor:
                                              RandomColor().randomColor(),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          "Loading!",
                                          // style: TextStyle(
                                          //   color: Colors.white,
                                          // ),
                                        )
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
                              userManagement.createUser(user.uid, {
                                "userName": user.displayName,
                                "email": user.email,
                                "photoUrl": user.photoUrl,
                                "userId": user.uid,
                              });
// Try to replace the login route with HomeScreen Route(AllNews()) because we are unable to go back to login screen again when pressing back button.
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //         builder: (context) => AllNews()));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllNews()),
                                (Route<dynamic> route) => false,
                              );

                              // Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
            );
          });
      /*Alert(
        context: context,
        type: AlertType.info,
        title: "No Internet",
        desc: "You are Offline.No Internet Please Connect To A Network!",
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          titleStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();*/
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
    }
  }
}
