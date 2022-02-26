import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/landing_screen.dart';
import 'package:roi_test/screens/login_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/onboarding_screen.dart';
import 'package:roi_test/widgets/curves2.dart';
import 'package:roi_test/widgets/dialogs/policy_dialog.dart';

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
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      if (mounted) {
        setState(() => this.hasInternet = hasInternet);
      }
    });
  }

  void onback() {
    AwesomeDialog(
      dialogBackgroundColor: white,
      context: context,
      dialogType: DialogType.WARNING,
      borderSide: BorderSide(color: white, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Exit',
      desc: 'Are sure you want to exit ?',
      buttonsTextStyle: TextStyle(fontSize: 12, color: primaryColor),
      showCloseIcon: true,
      btnCancelOnPress: () {
        Navigator.pushNamed(context, WelcomeScreen.id);
      },
      btnOkOnPress: () {
        SystemNavigator.pop();
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    //  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
          builder: (context) => StatefulBuilder(builder: (
                context,
                StateSetter mystate,
              ) {
                return Container(
                  height: MediaQuery.of(context).size.height / 2 +
                      MediaQuery.of(context).viewInsets.bottom,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(
                          height: 50,
                        ),
                        Text("WELCOME BACK !",
                            style: GoogleFonts.montserrat(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Sign in to your account',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        // Text('Enter your phone number to proceed',
                        //     style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: _validPhoneNumber
                                ? LinearGradient(
                                    // colors: [Color(0xffffd89b), cyan],
                                    colors: [harvey, cyan],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)
                                : LinearGradient(
                                    // colors: [Color(0xffffd89b), cyan],
                                    colors: [harvey, cyan],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                            color: _validPhoneNumber
                                ? Color(0xFF1B1F2E)
                                : Colors.grey,
                          ),
                          child: Row(children: [
                            Expanded(
                              flex: 1,
                              child: AbsorbPointer(
                                absorbing: _validPhoneNumber ? false : true,
                                child: TextButton(
                                  onPressed: () async {
                                    result = await Connectivity()
                                        .checkConnectivity();
                                    showTopSnackbar(result, context);
                                    mystate(() {
                                      auth.loading = true;
                                    });
                                    String number =
                                        '+91${_phoneNumbercontroller.text}';

                                    auth
                                        .verifyLoginPhone(
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
                                          style:
                                              TextStyle(color: Colors.white)),
                                  // style: ButtonStyle(
                                  //     backgroundColor:
                                  //         MaterialStateProperty.all(
                                  //             _validPhoneNumber
                                  //                 ? Color(0xFF1B1F2E)
                                  //                 : Colors.grey)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              "Don't have an account ?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            InkWell(
                                onTap: () {},
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)))
                          ],
                        )
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
    return WillPopScope(
      onWillPop: () {
        onback();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          //   key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  //   // clipBehavior: Clip.antiAliasWithSaveLayer,
                  clipper: BezierClipper(),
                  child: Container(
                    height: 350,
                    width: double.infinity,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Image.asset(
                            "images/splash.png",
                            height: 200,
                            width: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      auth.screen = 'Login';
                    });
                    showBottomSheet(context);
                  },
                  child: Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 3, color: cyan.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.transparent),
                    child: Center(
                        child: Text("Login",
                            style: GoogleFonts.poppins(
                                color: cyan,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 55,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [harvey, cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: TextButton(
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
                        : Text("Sign-Up",
                            style: GoogleFonts.poppins(
                                color: white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text:
                            'By creating an account,\tyou are agreeing to our\n',
                        style: GoogleFonts.poppins(color: black, fontSize: 12),
                        children: [
                          TextSpan(
                              text: 'Terms & Conditions\t',
                              style: GoogleFonts.poppins(
                                  color: cyan, fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PolicyDialog(
                                            mdFileName:
                                                'terms_and_conditions.md');
                                      });
                                }),
                          TextSpan(
                            text: 'and\t',
                          ),
                          TextSpan(
                              text: 'Privacy Policy!',
                              style: GoogleFonts.poppins(
                                  color: cyan, fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PolicyDialog(
                                            mdFileName: 'privacy_policy.md');
                                      });
                                }),
                          TextSpan(
                            text: 'and\t',
                          ),
                          TextSpan(
                              text: 'Refund & Cancellation!',
                              style: GoogleFonts.poppins(
                                  color: cyan, fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PolicyDialog(
                                            mdFileName: 'refund_policy.md');
                                      });
                                }),
                        ]),
                  ),
                ),
                //  Socialmedia()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTopSnackbar(ConnectivityResult result, BuildContext context) {
    var netConnect = false;

    if (result != ConnectivityResult.none) {
      netConnect = true;
    }

    if (result == ConnectivityResult.mobile) {
      Fluttertoast.showToast(
        msg: "Mobile Internet",
        gravity: ToastGravity.BOTTOM,
      );
    } else if (result == ConnectivityResult.wifi) {
      Fluttertoast.showToast(
        msg: "Wifi Internet",
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "No Internet",
        gravity: ToastGravity.BOTTOM,
      );
    }

    final message = netConnect ? 'You have Internet' : 'You have no Internet !';
    final color = netConnect ? Colors.green : Colors.red;

    showSimpleNotification(
      Text(
        message,
      ),
      background: color,
    );
  }
}
