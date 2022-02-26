import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';

import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/landing_screen.dart';
import 'package:roi_test/screens/login_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:roi_test/screens/main_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;
  GoogleMapController? _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User? user;
  @override
  void initState() {
    //checkuser logged in or not,while openingmap screen
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    //  User user = FirebaseAuth.instance.currentUser!;
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
        // user = FirebaseAuth.instance.currentUser!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(
      context,
    );
    final _auth = Provider.of<AuthProvider>(
      context,
    );

    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentLocation!, zoom: 14.4746),
            zoomControlsEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            onCameraMove: (CameraPosition position) {
              setState(() {
                _locating = true;
                // _mapController!.moveCamera(CameraUpdate.newLatLng(
                //   LatLng(locationData),
                // ));
              });
              locationData.onCameraMove(position);
            },
            onMapCreated: onCreated,
            onCameraIdle: () {
              setState(() {
                _locating = false;
              });
              locationData.getMoveCamera();
            },
          ),
          Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset(
                  "images/marker.png",
                  color: primaryColor,
                )),
          ),
          Center(
            child: SpinKitPulse(
              color: Colors.black,
              size: 100.0,
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _locating
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          )
                        : Container(),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_searching,
                          color: primaryColor,
                        ),
                        label: Text(
                          _locating
                              ? "Locating..."
                              : locationData.selectedAddress.featureName!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryColor),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        _locating
                            ? ""
                            : locationData.selectedAddress.addressLine!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AbsorbPointer(
                          absorbing: _locating ? true : false,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    _locating ? Colors.grey : primaryColor)),
                            onPressed: () {
                              //save address in shared preferences
                              locationData.savePrefs();
                              if (_loggedIn == false) {
                                Navigator.pushReplacementNamed(
                                    context, LoginScreen.id);
                              } else {
                                setState(() {
                                  _auth.latitude = locationData.latitude;
                                  _auth.longitude = locationData.longitude;
                                  _auth.address =
                                      locationData.selectedAddress.addressLine!;
                                  _auth.location =
                                      locationData.selectedAddress.featureName!;
                                });
                                _auth.updateUser(
                                  id: user!.uid,
                                  number: user!.phoneNumber,
                                );
                                // .then((value) {
                                //  if (value == true) {
                                Navigator.pushReplacementNamed(
                                    context, MainScreen.id);
                                // }
                                //  });
                              }
                            },
                            child: Center(
                                child: Text(
                              "Add Address",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
