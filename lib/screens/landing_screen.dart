import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/network/network_status.dart';
import 'package:roi_test/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  User user = FirebaseAuth.instance.currentUser!;
  String? _location;
  String? _address;
  bool loading = true;
  @override
  void initState() {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result) {
      if (result != null) {
        if (result.get('latitude') != null) {
          getPrefs(result);
        } else {
          _locationProvider.getCurrentPosition();
          if (_locationProvider.permissionAllowed == true) {
            Navigator.pushNamed(context, MapScreen.id);
          } else {
            print('permission not allowed');
          }
        }
      }
    });
    super.initState();
  }

  getPrefs(dbResult) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    if (location == null) {
      prefs.setString('address', dbResult.data()['location']);
      prefs.setString('location', dbResult.data()['address']);
      if (mounted) {
        setState(() {
          _location = dbResult.data()['location'];
          _address = dbResult.data()['address'];
          loading = false;
        });
      }
      Navigator.pushReplacementNamed(context, MainScreen.id);
    }
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return NetworkSensitive(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_location == null ? '' : _location!),
            ),
            Visibility(
              visible: _location != null ? true : false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Service Address not set',
                  // _address != null ? 'Service Address not set' : _address!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Visibility(
              visible: _location != null ? true : false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _address == null
                      ? 'Please update your Service Location'
                      : _address!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            CircularProgressIndicator(),
            Container(
                width: 200,
                child: Image.asset(
                  'images/landing.png',
                  fit: BoxFit.contain,
                  //   color: Colors.black12,
                )),
            Visibility(
              visible: _location != null ? true : false,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                },
                child: Text('Confirm Your Location',
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
              ),
            ),
            Visibility(
              visible: _location != null ? true : false,
              child: TextButton(
                onPressed: () {
                  _locationProvider.getCurrentPosition();
                  if (_locationProvider.selectedAddress != null) {
                    Navigator.pushReplacementNamed(context, MapScreen.id);
                  } else {
                    print('permission not allowed');
                  }
                },
                child: Text('Set your location',
                    //_location != null ? 'Update location' : 'Set Your Location',
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
