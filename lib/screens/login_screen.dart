import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/network/connectivity.dart';
import 'package:roi_test/screens/network/network_status.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//bool _validPhoneNumber = false;
//var _phoneNumbercontroller = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  final _phoneNumbercontroller = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    //  bool _validPhoneNumber = false;
    //var _phoneNumbercontroller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Container(
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
                            style: TextStyle(color: Colors.red, fontSize: 12))
                      ]),
                    )),
                Text('SIGN UP',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Enter your phone number to proceed',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                      prefixText: '+91', labelText: '10 digit mobile number'),
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumbercontroller,
                  onChanged: (value) {
                    if (value.length == 10) {
                      setState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      setState(() {
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
                        onPressed: () async {
                          result = await Connectivity().checkConnectivity();
                          showTopSnackbar(result, context);
                          //print(locationData.longitude);
                          // await Appservice().connection().then((hasinternet) {
                          //   if (hasinternet == null) {
                          //     Fluttertoast.showToast(
                          //       msg: "Check your Internet connection",
                          //       gravity: ToastGravity.BOTTOM,
                          //     );
                          //   } else {
                          if (mounted) {
                            setState(() {
                              auth.loading = true;
                              auth.screen = 'Mapscree';
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.address =
                                  locationData.selectedAddress.addressLine!;
                            });
                          }

                          String number = '+91${_phoneNumbercontroller.text}';
                          auth
                              .verifySignUpPhone(
                            context: context,
                            number: number,
                          )
                              .then((value) {
                            _phoneNumbercontroller.clear();
                            if (mounted) {
                              setState(() {
                                auth.loading = false;
                              });
                            }

                            //  Navigator.pushReplacementNamed(
                            //    context, HomeScreen.id);
                          });
                          //}
                          //});

                          //Navigator.pushReplacementNamed(
                          //   context, HomeScreen.id);
                        },
                        child: auth.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
