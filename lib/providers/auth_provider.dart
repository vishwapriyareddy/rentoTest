//import 'dart:ffi';

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/landing_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/network/network_status.dart';
import 'package:roi_test/services/user_services.dart';
import 'package:roi_test/widgets/curves2.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? smsOtp;
  String? verificationId;
  String error = "";
  late String screen;
  final UserServices _userServices = UserServices();
  bool loading = false;
  double? latitude;
  double? longitude;
  String? address;
  String? location;
  DocumentSnapshot? snapshot;
  LocationProvider locationData = LocationProvider();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isValidUser = false;

  Future<void> verifyLoginPhone({
    BuildContext? context,
    String? number,
  }) async {
    await _firestore
        .collection('users')
        .where('number', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });
    if (isValidUser) {
      this.loading = true;
      notifyListeners();
      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        this.loading = false;
        notifyListeners();
        await _auth.signInWithCredential(credential);
      };
      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException e) {
        this.loading = false;
        print(e.code);
        this.error = e.toString();
        notifyListeners();
      };
      final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
        verificationId = verId;
        smsOtpDialog(context!, number!);
      };
      try {
        _auth.verifyPhoneNumber(
            phoneNumber: number!,
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: smsOtpSend,
            codeAutoRetrievalTimeout: (String verId) {
              verificationId = verId;
            });
      } catch (e) {
        this.error = e.toString();
        this.loading = false;
        notifyListeners();
        print(e);
      }
    } else {
      this.loading = false;
      notifyListeners();
      Fluttertoast.showToast(
        msg: "Number not found , Sign up first",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> verifySignUpPhone({
    BuildContext? context,
    String? number,
  }) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      smsOtpDialog(context!, number!);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number!,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          });
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(
    BuildContext context,
    String number,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipPath(
                    //   // clipBehavior: Clip.antiAliasWithSaveLayer,
                    clipper: BezierClipper(),
                    child: Container(
                      height: 220,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 25, top: 30),
                          //   child: Icon(
                          //     CupertinoIcons.back,
                          //     color: white,
                          //     size: 30,
                          //   ),
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Verification Code",
                              style: GoogleFonts.montserrat(
                                  color: white, fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 10),
                            child: Text(
                              "Enter OTP received as SMS",
                              style: GoogleFonts.montserrat(
                                  color: white, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text('Verification Code',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onChanged: (value) {
                        smsOtp = value;
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: cyan),
                    child: TextButton(
                        onPressed: () async {
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId!,
                                    smsCode: smsOtp!);
                            final User? user =
                                (await _auth.signInWithCredential(credential))
                                    .user;
                            if (user != null) {
                              this.loading = false;
                              notifyListeners();
                              _userServices
                                  .getUserById(user.uid)
                                  .then((snapShot) {
                                if (snapShot.exists) {
                                  //user data already exists
                                  if (this.screen == 'Login') {
                                    //need to check if user data already existed or not in db,
                                    //if its Login. no new data,so no need to update
                                    Navigator.pushReplacementNamed(
                                        context, LandingScreen.id);
                                  } else {
                                    //need to update new selected address.
                                    updateUser(
                                        id: user.uid, number: user.phoneNumber);
                                    Navigator.pushReplacementNamed(
                                        context, MainScreen.id);
                                  }
                                } else {
                                  //user data does not exists
                                  //will create new data in db
                                  _createUser(
                                      id: user.uid, number: user.phoneNumber);
                                  Navigator.pushReplacementNamed(
                                      context, LandingScreen.id);
                                }
                              });
                            } else {
                              print('Login Failed');
                            }
                          } catch (e) {
                            error = 'Invalid OTP';
                            print(e.toString());
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Submit',
                          style: GoogleFonts.montserrat(
                              color: white, fontSize: 18),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({
    String? id,
    String? number,
  }) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location,
      'firstName': '',
      'lastName': '',
      'email': '',
      // 'star': '',
      // 'comments': '',
    });
    this.loading = false;
    notifyListeners();
  }

  void updateUser({
    String? id,
    String? number,
  }) {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location,
        // 'firstName': '',
        // 'lastName': '',
        // 'email': '',
        // 'star': '',
        // 'comments': '',
      });
      this.loading = false;
      notifyListeners();
      //return true;
    } catch (e) {
      print('Error $e');
      //return false;
    }
  }

  // void updateUserRatings({String? id, double? star, String? comments}) {
  //   try {
  //     _userServices.updateUserData({
  //       'id': id,
  //       //'number': number,
  //       // 'latitude': this.latitude,
  //       // 'longitude': this.longitude,
  //       // 'address': this.address,
  //       // 'location': this.location,
  //       // 'firstName': '',
  //       // 'lastName': '',
  //       // 'email': '',
  //       'star': star,
  //       'comments': comments,
  //     });
  //     this.loading = false;
  //     notifyListeners();
  //     //return true;
  //   } catch (e) {
  //     print('Error $e');
  //     //return false;
  //   }
  // }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      this.snapshot = null;
      notifyListeners();
    }
    return result;
  }

  // Future<DocumentSnapshot> getUserDetails() async {
  //   DocumentSnapshot result = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_auth.currentUser!.uid)
  //       .get();
  //   this.snapshot = result;
  //   notifyListeners();
  //   return result;
  // }
}
