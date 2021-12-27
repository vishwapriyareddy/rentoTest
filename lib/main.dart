// ignore_for_file: prefer_const_constructors

import 'dart:async';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/login_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/product_details_screen.dart';
import 'package:roi_test/screens/product_list.dart';

import 'package:roi_test/screens/splash_screen.dart';
import 'package:roi_test/screens/vendor_home_screen.dart';
import 'package:roi_test/models/product_display.dart';

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
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => ServiceStore())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Color(0xFF3c5784), fontFamily: 'Lato'),
          initialRoute: SplashScreen.id,
          onGenerateRoute: (settings) {
            if (settings.name == ProductDetailsScreen.id) {
              // Cast the arguments to the correct
              // type: ScreenArguments.
              final args = settings.arguments as ProductDetails;

              // Then, extract the required data from
              // the arguments and pass the data to the
              // correct screen.
              return MaterialPageRoute(
                builder: (context) {
                  return ProductDetailsScreen(
                    document: args.document,
                  );
                },
              );
            }
            // The code only supports
            // PassArgumentsScreen.routeName right now.
            // Other values need to be implemented if we
            // add them. The assertion here will help remind
            // us of that higher up in the call stack, since
            // this assertion would otherwise fire somewhere
            // in the framework.
            assert(false, 'Need to implement ${settings.name}');
            return null;
          },
          routes: {
            SplashScreen.id: (context) => SplashScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            WelcomeScreen.id: (context) => WelcomeScreen(),
            MapScreen.id: (context) => MapScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            MainScreen.id: (context) => MainScreen(),
            VendorHomeScreen.id: (context) => VendorHomeScreen(),
            ProductList.id: (context) => ProductList(),
          },
        ));
  }
}
