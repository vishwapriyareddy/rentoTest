import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/welcome_screen.dart';
import 'package:roi_test/widgets/image_slider.dart';
import 'package:roi_test/widgets/my_appbar.dart';
import 'package:roi_test/widgets/top_pick_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
        appBar: PreferredSize(
            child: MyAppBar(), preferredSize: Size.fromHeight(112)),
        body: Center(
            child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            ImageSlider(), Container(height: 300, child: TopPickService())
            // ElevatedButton(
            //     onPressed: () {
            //       auth.error = '';
            //       FirebaseAuth.instance.signOut().then((value) {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => WelcomeScreen()));
            //       });
            //     },
            //     child: Text('Sign Out')),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
            //     },
            //     child: Text('Home Screen')),
          ],
        )));
  }
}
