import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/location_provider.dart';

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
                Text('LOGIN',
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
                        onPressed: () {
                          //print(locationData.longitude);
                          setState(() {
                            auth.loading = true;
                            auth.screen = 'Mapscree';
                            auth.latitude = locationData.latitude;
                            auth.longitude = locationData.longitude;
                            auth.address = locationData.selectedAddress!;
                          });
                          String number = '+91${_phoneNumbercontroller.text}';
                          auth
                              .verifyPhone(
                            context: context,
                            number: number,
                          )
                              .then((value) {
                            _phoneNumbercontroller.clear();
                            setState(() {
                              auth.loading = false;
                            });
                            //  Navigator.pushReplacementNamed(
                            //    context, HomeScreen.id);
                          });
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
}
