import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/screens/Help/contactUs.dart';
import 'package:roi_test/screens/login_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/network/network_status.dart';
import 'package:roi_test/screens/profile_update.dart';
import 'package:roi_test/screens/welcome_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _firstName = "";
  String _email = "";
  String _lastName = "";
  User user = FirebaseAuth.instance.currentUser!;
  Future<void> getuser() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      if (mounted) {
        if (value != null) {
          setState(() {
            _firstName = value.data()!['firstName'].toString();
            _lastName = value.data()!['lastName'].toString();
            _email = value.data()!['email'].toString();
          });
        } else {
          return null;
        }
      }
    });
  }

  @override
  void initState() {
    //  if (mounted) {

    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    User user = FirebaseAuth.instance.currentUser!;
    userDetails.getUserDetails();
    return NetworkSensitive(
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cyan,
                          gradient: LinearGradient(
                              colors: [cyan, harvey],
                              begin: Alignment.bottomLeft),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: white.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5)),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 50),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: MainScreen.id),
                                          screen: MainScreen(),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      icon: Icon(
                                        CupertinoIcons.arrow_left,
                                        color: white,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 85),
                                    child: Text('My Account',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 20, color: white)),
                                  )
                                ],
                              ),
                              SizedBox(height: 15),
                              _firstName.length > 2
                                  ? Text("${_firstName} ${_lastName}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18, color: white))
                                  : Text("Your name",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18, color: white)),
                              SizedBox(height: 5),
                              if (_email.length > 2)
                                Text("${_email}",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14, color: white)),
                              SizedBox(height: 5),
                              Text(user.phoneNumber!,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, color: white)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            child: Center(
                                child: Text(
                              'J',
                              style: TextStyle(fontSize: 40, color: white),
                            )),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.white, width: 4)),
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: white.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stickingtitle(
                          icon: Icon(Icons.person_outline, color: cyan),
                          text: Text("Profile"),
                          onTap: () {
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: UpdateProfile.id),
                              screen: UpdateProfile(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                        ),
                        Stickingtitle(
                          icon: Icon(Icons.assignment_outlined, color: cyan),
                          text: Text("Contact Us"),
                          onTap: () {
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: ContactUs.id),
                              screen: ContactUs(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                        ),
                        Stickingtitle(
                          icon: Icon(Icons.notifications_outlined, color: cyan),
                          text: Text("Notifications"),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: white.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stickingtitle(
                          icon: Icon(Icons.brightness_6_outlined, color: cyan),
                          text: Text("Theme"),
                          onTap: () {},
                        ),
                        Stickingtitle(
                          icon: Icon(Icons.rate_review_outlined, color: cyan),
                          text: Text("Rating & Reviews"),
                          onTap: () {
                            show();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: white.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stickingtitle(
                          icon: Icon(Icons.help_outline_sharp, color: cyan),
                          text: Text("Help & Faq"),
                          onTap: () {},
                        ),
                        Stickingtitle(
                          icon: Icon(Icons.logout, color: cyan),
                          text: Text("Log out"),
                          onTap: () {
                            _auth.signOut().then((value) {
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: WelcomeScreen.id),
                                screen: WelcomeScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> show() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          // final _auth = Provider.of<AuthProvider>(
          //   context,
          // );
          return RatingDialog(
              title: Text(
                'ROI APP',
                style: TextStyle(color: cyan, fontSize: 20),
              ),
              message: Text(
                'Tap on Star to rate us',
                style: TextStyle(color: cyan, fontSize: 16),
              ),
              image: Icon(
                Icons.star,
                size: 100,
                color: Colors.green,
              ),
              submitButtonText: 'SUBMIT',
              onSubmitted: (response) {
                double? rating = response.rating;
                String? comment = response.comment;
                print(
                    'onSubmittedPressed: rating = ${response.rating} , comment = ${response.comment}');
                // _auth.updateUserRatings(
                //     id: user.uid, star: rating.toDouble(), comments: comment);
              });
        });
  }
}

class Stickingtitle extends StatelessWidget {
  final Icon icon;
  final Widget text;
  final VoidCallback onTap;

  const Stickingtitle({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            icon,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Colors.grey.withOpacity(0.3),
            ),
            Expanded(
              child: text,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}
