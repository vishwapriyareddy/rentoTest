// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:roi_test/constants.dart';
// import 'package:roi_test/providers/auth_provider.dart';
// import 'package:roi_test/providers/location_provider.dart';
// import 'package:roi_test/screens/main_screen.dart';
// import 'package:roi_test/screens/network/connectivity.dart';
// import 'package:roi_test/screens/network/network_status.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:roi_test/screens/welcome_screen.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// class LoginScreen extends StatefulWidget {
//   static const String id = 'login-screen';
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _formKeyOTP = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController cellnumberController = TextEditingController();
//   // final TextEditingController otpController = new TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   // final TextEditingController emailController = new TextEditingController();
//   final _addressTextController = TextEditingController();

//   var isLoading = false;
//   var isResend = false;
//   var isRegister = true;
//   var isOTPScreen = false;
//   var verificationCode = '';
//   late String phone;
//   late String otpcoder;
//   double? latitude;
//   double? longitude;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     cellnumberController.dispose();
//     // otpController.dispose();
//     locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     final node = FocusScope.of(context);
//     final location = Provider.of<LocationProvider>(context);

//     return isOTPScreen ? otpscreenpage() : signupscreen();
//   }

//   signupscreen() {
//     void onback() {
//       Navigator.pushNamed(context, WelcomeScreen.id);
//     }

//     final location = Provider.of<LocationProvider>(context);

//     final node = FocusScope.of(context);
//     return WillPopScope(
//       onWillPop: () {
//         onback();
//         return Future.value(false);
//       },
//       child: SafeArea(
//         child: Scaffold(
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: 220,
//                   width: double.infinity,
//                   decoration: new BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         offset: Offset(0.0, 1.0), //(x,y)
//                         blurRadius: 6.0,
//                       )
//                     ],
//                     color: white,
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20),
//                         child: Image.asset(
//                           "assets/icons/ilatri.png",
//                           height: 65,
//                         ),
//                       ),
//                       Image.asset(
//                         "assets/icons/titleb.png",
//                         height: 90,
//                         width: 300,
//                         color: black,
//                       ),
//                       // TextButton(
//                       //     onPressed: () => Navigator.pushReplacement(
//                       //         context,
//                       //         MaterialPageRoute(
//                       //             builder: (context) => Mainhome())),
//                       //     child: Text("data"))
//                     ],
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: height * 0.01.h,
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Text(
//                           "Become a part of ILA",
//                           style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               Container(
//                                   child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 0.0, horizontal: 10.0),
//                                 child: TextFormField(
//                                   enabled: !isLoading,
//                                   controller: nameController,
//                                   textInputAction: TextInputAction.next,
//                                   onEditingComplete: () => node.nextFocus(),
//                                   decoration: InputDecoration(
//                                       // floatingLabelBehavior:
//                                       //     FloatingLabelBehavior.never,
//                                       prefixIcon: Icon(
//                                         Icons.person,
//                                         color: cyan,
//                                       ),
//                                       labelText: "User name",
//                                       hintText: "User name",
//                                       labelStyle: TextStyle(color: cyan)),
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please enter your name';
//                                     }
//                                   },
//                                 ),
//                               )),
//                               Container(
//                                   child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10.0),
//                                 child: TextFormField(
//                                   enabled: !isLoading,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please enter your mobile no.';
//                                     }
//                                   },
//                                   maxLength: 10,
//                                   keyboardType: TextInputType.phone,
//                                   textInputAction: TextInputAction.done,
//                                   decoration: InputDecoration(
//                                     // labelText: 'Phone Number',
//                                     //  prefixIcon: Icon(
//                                     //   Icons.phone,
//                                     //   color: navy,
//                                     // ),
//                                     labelText: "Mobile no.",
//                                     hintText: "Mobile ",
//                                     labelStyle: TextStyle(color: cyan),
//                                     // border: OutlineInputBorder(
//                                     //     borderSide: BorderSide())
//                                   ),

//                                   // controller: cellnumberController,
//                                   onChanged: (phoneNumber) {
//                                     setState(() {
//                                       phone = phoneNumber;
//                                       print(phone);
//                                     });
//                                   },
//                                 ),
//                               )),
//                               Container(
//                                   child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10.0),
//                                 child: TextFormField(
//                                     maxLines: 6,
//                                     controller: _addressTextController,
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return "Please press Navigation button";
//                                       }
//                                       if (location.longitude == null) {
//                                         return "Please press Navigation button";
//                                       }
//                                       return null;
//                                     },
//                                     decoration: InputDecoration(
//                                         prefixIcon:
//                                             Icon(Icons.contact_mail_outlined),
//                                         suffixIcon: IconButton(
//                                             onPressed: () {
//                                               _addressTextController.text =
//                                                   'Locating...\nPlease wait...';
//                                               location
//                                                   .getCurrentPosition()
//                                                   .then((address) {
//                                                 if (address != null) {
//                                                   setState(() {
//                                                     _addressTextController
//                                                             .text =
//                                                         '${location.longitude}';
//                                                   });
//                                                 } else {
//                                                   ScaffoldMessenger.of(context)
//                                                       .showSnackBar(SnackBar(
//                                                           content: Text(
//                                                               'Could not find location...Try again')));
//                                                 }
//                                               });
//                                             },
//                                             icon:
//                                                 Icon(Icons.location_searching)),
//                                         labelText: 'Your Location',
//                                         //  contentPadding: EdgeInsets.zero,
//                                         enabledBorder: OutlineInputBorder(),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 width: 2,
//                                                 color: Theme.of(context)
//                                                     .primaryColor)),
//                                         focusColor:
//                                             Theme.of(context).primaryColor)),
//                               )),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   Text("Already a user?"),
//                                   TextButton(
//                                       onPressed: () {
//                                         Navigator.pushNamed(
//                                             context, WelcomeScreen.id);
//                                       },
//                                       child: Text(
//                                         "Log in",
//                                         style: GoogleFonts.poppins(
//                                             color: Color(0xff5770B5),
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ))
//                                 ],
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   if (!isLoading) {
//                                     if (_formKey.currentState!.validate()) {
//                                       if (mounted) {
//                                         setState(() {
//                                           signUp();
//                                           isRegister = false;
//                                           isOTPScreen = true;
//                                         });
//                                       }
//                                     }
//                                   }
//                                 },
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: white,
//                                         border:
//                                             Border.all(color: Colors.black)),
//                                     height: 50,
//                                     width: 200,
//                                     // padding: const EdgeInsets.symmetric(
//                                     //   vertical: 15.0,
//                                     //   horizontal: 15.0,
//                                     // ),
//                                     child: Center(
//                                       child: Text(
//                                         "Sign up",
//                                         style: TextStyle(color: cyan),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void showTopSnackbar(ConnectivityResult result, BuildContext context) {
//     var netConnect = false;

//     if (result != ConnectivityResult.none) {
//       netConnect = true;
//     }

//     if (result == ConnectivityResult.mobile) {
//       Fluttertoast.showToast(
//         msg: "Mobile Internet",
//         gravity: ToastGravity.BOTTOM,
//       );
//     } else if (result == ConnectivityResult.wifi) {
//       Fluttertoast.showToast(
//         msg: "Wifi Internet",
//         gravity: ToastGravity.BOTTOM,
//       );
//     } else {
//       Fluttertoast.showToast(
//         msg: "No Internet",
//         gravity: ToastGravity.BOTTOM,
//       );
//     }

//     final message = netConnect ? 'You have Internet' : 'You have no Internet !';
//     final color = netConnect ? Colors.green : Colors.red;

//     showSimpleNotification(
//       Text(
//         message,
//       ),
//       background: color,
//     );
//   }

//   otpscreenpage() {
//     void onback() {
//       Navigator.pushNamed(context, WelcomeScreen.id);
//     }

//     final location = Provider.of<LocationProvider>(context);
// //    final auth = Provider.of<AuthProvider>(context);
//     //  double height = MediaQuery.of(context).size.height;
//     //double width = MediaQuery.of(context).size.width;
//     return WillPopScope(
//       onWillPop: () {
//         onback();
//         return Future.value(false);
//       },
//       child: SafeArea(
//         child: WillPopScope(
//           onWillPop: () {
//             onback();
//             return Future.value(false);
//           },
//           child: Scaffold(
//             key: _scaffoldKey,
//             body: SingleChildScrollView(
//               child: Column(children: [
//                 Center(
//                   child: Form(
//                     key: _formKeyOTP,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           color: white,
//                           height: 250,
//                           width: double.infinity,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 25),
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Text(
//                           isLoading
//                               ? "Verify your OTP"
//                               : "The code has been sent to\n your mobile via SMS",
//                           style: GoogleFonts.poppins(
//                               fontSize: 15,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         !isLoading
//                             ? Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 50),
//                                 child: TextFormField(
//                                   maxLength: 6,
//                                   onChanged: (val) {
//                                     otpcoder = val;
//                                     // FocusScope.of(context)
//                                     //     .requestFocus(FocusNode());
//                                   },
//                                   keyboardType: TextInputType.number,
//                                   // autoFocus: true,
//                                 ),
//                               )
//                             : Container(),
//                         !isLoading
//                             ? Container(
//                                 margin: EdgeInsets.only(top: 40, bottom: 5),
//                                 child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10.0),
//                                     child: new TextButton(
//                                       onPressed: () async {
//                                         if (_formKeyOTP.currentState!
//                                             .validate()) {
//                                           if (mounted) {
//                                             setState(() {
//                                               isResend = false;
//                                               isLoading = true;
//                                             });
//                                           }
//                                           try {
//                                             await _auth
//                                                 .signInWithCredential(
//                                                     PhoneAuthProvider.credential(
//                                                         verificationId:
//                                                             verificationCode,
//                                                         smsCode: otpcoder
//                                                             .toString()))
//                                                 .then((user) async => {
//                                                       if (user != null)
//                                                         {
//                                                           await _firestore
//                                                               .collection(
//                                                                   'users')
//                                                               .doc(_auth
//                                                                   .currentUser!
//                                                                   .uid)
//                                                               .set(
//                                                                   {
//                                                                 'name':
//                                                                     nameController
//                                                                         .text
//                                                                         .trim(),
//                                                                 'number': phone
//                                                                     .trim(),
//                                                                 'location':
//                                                                     _addressTextController
//                                                                         .text
//                                                                         .trim(),
//                                                                 'latitude':
//                                                                     location
//                                                                         .latitude,
//                                                                 'longitude':
//                                                                     location
//                                                                         .longitude
//                                                                 // 'email':
//                                                                 //     emailController
//                                                                 //         .text
//                                                                 //         .trim(),
//                                                               },
//                                                                   SetOptions(
//                                                                       merge:
//                                                                           true)).then(
//                                                                   (value) => {
//                                                                         //then move to authorised area
//                                                                         setState(
//                                                                             () {
//                                                                           isLoading =
//                                                                               false;
//                                                                           isResend =
//                                                                               false;
//                                                                         })
//                                                                       }),
//                                                           if (mounted)
//                                                             {
//                                                               setState(() {
//                                                                 isLoading =
//                                                                     false;
//                                                                 isResend =
//                                                                     false;
//                                                               })
//                                                             },
//                                                           Navigator
//                                                               .pushAndRemoveUntil(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (BuildContext
//                                                                       context) =>
//                                                                   MainScreen(),
//                                                             ),
//                                                             (route) => false,
//                                                           )
//                                                         }
//                                                     })
//                                                 .catchError((error) => {
//                                                       if (mounted)
//                                                         {
//                                                           setState(() {
//                                                             isLoading = false;
//                                                             isResend = true;
//                                                           })
//                                                         },
//                                                     });
//                                             if (mounted) {
//                                               setState(() {
//                                                 isLoading = true;
//                                               });
//                                             }
//                                           } catch (e) {
//                                             if (mounted) {
//                                               setState(() {
//                                                 isLoading = false;
//                                               });
//                                             }
//                                           }
//                                         }
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                             color: white,
//                                             border: Border.all(color: black)),
//                                         height: 50,
//                                         width: 200,
//                                         child: Material(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           elevation: 4,
//                                           color: white,
//                                           child: Center(
//                                               child: Text('Submit',
//                                                   style: GoogleFonts.poppins(
//                                                       // fontWeight:
//                                                       //     FontWeight.bold,
//                                                       color: black,
//                                                       fontSize: 15))),
//                                         ),
//                                       ),
//                                     )))
//                             : Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         CircularProgressIndicator(
//                                           color: Colors.green,
//                                         )
//                                       ].where((c) => c != null).toList(),
//                                     )
//                                   ]),
//                         isResend
//                             ? Container(
//                                 margin: EdgeInsets.only(top: 20),
//                                 child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10.0),
//                                     child: new TextButton(
//                                       onPressed: () async {
//                                         if (mounted) {
//                                           setState(() {
//                                             isResend = false;
//                                             isLoading = true;
//                                           });
//                                         }
//                                         await signUp();
//                                       },
//                                       child: new Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                             color: white,
//                                             border: Border.all(color: cyan)),
//                                         height: 50,
//                                         width: 200,
//                                         child: Center(
//                                             child: Text('Resend Code',
//                                                 style: GoogleFonts.poppins(
//                                                     // fontWeight:
//                                                     //     FontWeight.bold,
//                                                     color: black,
//                                                     fontSize: 20))),
//                                       ),
//                                     )))
//                             : Column(),
//                         SizedBox(
//                           height: 20,
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future signUp() async {
//     if (mounted) {
//       setState(() {
//         isLoading = true;
//       });
//     }
//     final location = Provider.of<LocationProvider>(context);

//     var phonenumber = phone;
//     var verifyphone = _auth.verifyPhoneNumber(
//         phoneNumber: phonenumber,
//         verificationCompleted: (phoneauthcredential) {
//           _auth.signInWithCredential(phoneauthcredential).then((user) async => {
//                 if (user != null)
//                   {
//                     await _firestore
//                         .collection("users")
//                         .doc(_auth.currentUser!.uid)
//                         .set({
//                           "name": nameController.text.trim(),
//                           "cellnumber": phone.trim(),
//                           "location": _addressTextController.text.trim(),
//                           'latitude': location.latitude,
//                           'longitude': location.longitude
//                           // "email": emailController.text.trim(),
//                         }, SetOptions(merge: true))
//                         .then((value) => {
//                               if (mounted)
//                                 {
//                                   setState(() {
//                                     isLoading = false;
//                                     isRegister = false;
//                                     isOTPScreen = false;

//                                     //navigate to is
//                                     Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             MainScreen(),
//                                       ),
//                                       (route) => false,
//                                     );
//                                   })
//                                 }
//                             })
//                         .catchError((onError) => {
//                               debugPrint("Error saving user to db." +
//                                   onError.toString()),
//                               Fluttertoast.showToast(msg: onError.toString())
//                             })
//                   }
//               });
//         },
//         verificationFailed: (error) {
//           setState(() {
//             isLoading = false;
//           });
//         },
//         codeSent: (verificationID, [forceResendingToken]) {
//           setState(() {
//             isLoading = false;
//             verificationCode = verificationID;
//           });
//         },
//         codeAutoRetrievalTimeout: (verificationID) {
//           setState(() {
//             isLoading = false;
//             verificationCode = verificationID;
//           });
//         },
//         timeout: Duration(seconds: 60));
//     await verifyphone;
//   }
// }

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
                              .verifyPhone(
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
