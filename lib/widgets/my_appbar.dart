import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/welcome_screen.dart';
import 'package:roi_test/services/user_services.dart';
import 'package:roi_test/widgets/curves2.dart';
import 'package:roi_test/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = '';
  String _address = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    String? address = prefs.getString('address');

    setState(() {
      _location = location!;
      _address = address!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
              child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: BezierClipper(),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        // colors: [Color(0xffffd89b), cyan],
                        colors: [harvey, cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    // gradient: LinearGradient(
                    //     colors: [cyan, Color(0xffffd89b),],
                    //     begin: Alignment.topLeft,end: Alignment.bottomRight),
                    // color:
                    //     Color.fromARGB(255, 9, 163, 184).withOpacity(0.9)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Image.asset("images/splash.png")),
                            ),
                            // IconButton(
                            //   icon: Icon(
                            //     Icons.sort,
                            //     color: Colors.black87,
                            //     size: 30,
                            //   ),
                            //   onPressed: () => {},
                            // ),
                            IconButton(
                              color: white,
                              icon: Icon(
                                CupertinoIcons.cart_fill,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Hi Anup!",
                            // style: TextStyle(fontSize: 25,color: Colors.white),
                            style: GoogleFonts.montserrat(
                                fontSize: 25, color: white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Locationfetch(
                            locationData: locationData,
                            address: _address,
                            location: _location,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Serachbarwidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
    // actions: [
    //   IconButton(
    //     icon: Icon(Icons.power_settings_new),
    //     onPressed: () {
    //       FirebaseAuth.instance.signOut();
    //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    //     },
    //   ),
    //   IconButton(
    //     icon: Icon(Icons.account_circle_outlined),
    //     onPressed: () {},
    //   )
    // ],
  }
}

class Locationfetch extends StatelessWidget {
  const Locationfetch({
    Key? key,
    required this.locationData,
    required String address,
    required String location,
  })  : _address = address,
        _location = location,
        super(key: key);

  final LocationProvider locationData;
  final String _address;
  final String _location;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          locationData.getCurrentPosition().then((value) {
            if (locationData.permissionAllowed == true) {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: MapScreen.id),
                screen: MapScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            } else {
              print('Permission not allowed');
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        _location == null
                            ? 'Press here to set your service location'
                            : '$_location',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    '$_address',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ],
        ));
  }
}
