import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/services/user_services.dart';

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
  LocationProvider locationData = LocationProvider();
  Future<void> verifyPhone({
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
          return AlertDialog(
            title: Column(
              children: [
                Text('Verifiaction Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter OTP received as SMS',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  smsOtp = value;
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId!,
                              smsCode: smsOtp!);
                      final User? user =
                          (await _auth.signInWithCredential(credential)).user;
                      if (user != null) {
                        this.loading = false;
                        notifyListeners();
                        _userServices.getUserById(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            //user data already exists
                            if (this.screen == 'Login') {
                              //need to check if user data already existed or not in db,
                              //if its Login. no new data,so no need to update
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.id);
                            } else {
                              //need to update new selected address.
                              updateUser(
                                  id: user.uid, number: user.phoneNumber);
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.id);
                            }
                          } else {
                            //user data does not exists
                            //will create new data in db
                            _createUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
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
                  child: Text('DONE'))
            ],
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
      'address': this.address
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
        'address': this.address
      });
      this.loading = false;
      notifyListeners();
      //return true;
    } catch (e) {
      print('Error $e');
      //return false;
    }
  }
}
