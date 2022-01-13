import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';

import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/landing_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _WelcomeScreenState extends State<WelcomeScreen> {
  // @override
  // void initState() {
  //   Timer.run(() {
  //     if (_auth.currentUser != null) {
  //       Navigator.pushReplacementNamed(context, LandingScreen.id);
  //     } else {
  //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  //     }
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumbercontroller = TextEditingController();
    void showBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          builder: (context) =>
              StatefulBuilder(builder: (context, StateSetter mystate) {
                return Container(
                  height: MediaQuery.of(context).size.height / 2 +
                      MediaQuery.of(context).viewInsets.bottom,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible: auth.error == 'Invalid OTP' ? true : false,
                            child: Container(
                              child: Column(children: [
                                Text(auth.error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12))
                              ]),
                            )),
                        Text('LOGIN',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Enter your phone number to proceed',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(height: 30),
                        TextField(
                          decoration: InputDecoration(
                              prefixText: '+91',
                              labelText: '10 digit mobile number'),
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          controller: _phoneNumbercontroller,
                          onChanged: (value) {
                            if (value.length == 10) {
                              mystate(() {
                                _validPhoneNumber = true;
                              });
                            } else {
                              mystate(() {
                                _validPhoneNumber = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Expanded(
                            flex: 1,
                            child: AbsorbPointer(
                              absorbing: _validPhoneNumber ? false : true,
                              child: TextButton(
                                onPressed: () {
                                  mystate(() {
                                    auth.loading = true;
                                  });
                                  String number =
                                      '+91${_phoneNumbercontroller.text}';
                                  auth
                                      .verifyPhone(
                                    context: context,
                                    number: number,
                                  )
                                      .then((value) {
                                    _phoneNumbercontroller.clear();
                                    // mystate(() {
                                    //   auth.loading = false;
                                    // });
                                  });
                                },
                                child: auth.loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        _validPhoneNumber
                                            ? 'CONTINUE'
                                            : 'ENTER PHONE NUMBER',
                                        style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _validPhoneNumber
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey)),
                              ),
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                );
              })).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumbercontroller.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: OnboardingScreen()),
                  Text(
                    'Ready to book your service?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        locationData.loading = true;
                      });

                      await locationData.getCurrentPosition();
                      if (locationData.permissionAllowed == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen()));
                        setState(() {
                          locationData.loading = false;
                        });
                      } else {
                        print('Permission not allowed');
                        setState(() {
                          locationData.loading = false;
                        });
                      }
                    },
                    child: locationData.loading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('Set Service Location',
                            style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          auth.screen = 'Login';
                        });
                        showBottomSheet(context);
                      },
                      child: RichText(
                        text: TextSpan(
                            text: 'Already a Customer?',
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor))
                            ]),
                      ))
                ],
              ),
            ],
          )),
    );
  }
}
