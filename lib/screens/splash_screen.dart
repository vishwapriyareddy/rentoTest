import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/landing_screen.dart';
import 'package:roi_test/screens/main_screen.dart';

import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _SplashScreenState extends State<SplashScreen> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    Timer.run(() {
      //   Navigator.pushReplacement(
      //context,
      //MaterialPageRoute(
      // builder: (context) => WelcomeScreen(),
      // ));

      if (_auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, LandingScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
            duration: 1000,
            splashTransition: SplashTransition.fadeTransition,
            splashIconSize: deviceWidth(context) * 0.8,
            splash: Image.asset(
              "images/splash.png",
              fit: BoxFit.contain,
            ),
            nextScreen: WelcomeScreen())
        //Center(
        // child: Padding(
        //   padding: EdgeInsets.only(
        //     top: deviceHeight(context) * 0.09,
        //     left: deviceWidth(context) * 0.09,
        //     right: deviceWidth(context) * 0.09,
        //     bottom: deviceHeight(context) * 0.09,
        //   ),
        //   child: Hero(tag: 'logo', child: Image.asset('images/splash.png')),
        // ),
        //),
        );
  }
}
