import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _address = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');

    setState(() {
      _address = address!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      elevation: 0.0,
      // leading: Container(),
      title: TextButton(
          onPressed: () {
            locationData.getCurrentPosition();
            if (locationData.permissionAllowed == true) {
              Navigator.pushNamed(context, MapScreen.id);
            } else {
              print('Permission not allowed');
            }
          },
          child: Row(
            children: [
              Flexible(
                child: Text(
                  _address != null
                      ? _address
                      : 'Press here to set your delivery location',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 15,
              ),
            ],
          )),
      actions: [
        IconButton(
          icon: Icon(Icons.power_settings_new),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle_outlined),
          onPressed: () {},
        )
      ],
      centerTitle: false,
      bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white),
            ),
          ),
          preferredSize: Size.fromHeight(56)),
    );
  }
}
