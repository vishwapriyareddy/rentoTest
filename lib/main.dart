// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/login_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/splash_screen.dart';

import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // mAuth.getFirebaseAuthSettings().setAppVerificationDisabledForTesting(true);
  // (MultiProvider(
  //   providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
  //   child: runApp(MyApp()),
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Color(0xFF3c5784), fontFamily: 'Lato'),
          initialRoute: SplashScreen.id,
          routes: {
            SplashScreen.id: (context) => SplashScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            WelcomeScreen.id: (context) => WelcomeScreen(),
            MapScreen.id: (context) => MapScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            MainScreen.id: (context) => MainScreen(),
          },
        ));
  }
}
