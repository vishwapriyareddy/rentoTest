//import 'dart:html'
import 'package:flutter/material.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/screens/Help/faq.dart';
import 'package:roi_test/screens/Help/mapLocation.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  static const String id = 'contact-us';
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('could not launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Contact Us",
          style: TextStyle(color: primaryColor),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Center(
                child: Image.asset("images/contactus2.png",
                    height: MediaQuery.of(context).size.height * 0.25)),
            SizedBox(
              height: 10,
            ),
            Text(
              "Have an issue or query? \n Feel free to contact us",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: primaryColor),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    launch(
                        'mailto:help@email.com?subject=I have a query&body=About%20the');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(1, 10))
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.alternate_email,
                              color: primaryColor,
                              size: 50,
                            ),
                            Text(
                              'Write to us :',
                              style: TextStyle(color: primaryColor),
                            ),
                            Text('info@rentointegrated.com')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    customLaunch("tel:+91 89 4038 1000");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(1, 10))
                      ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: primaryColor,
                            size: 50,
                          ),
                          Text('Call us :',
                              style: TextStyle(color: primaryColor)),
                          Text('+91 89 4038 1000')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(1, 10))
                      ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: primaryColor,
                            size: 50,
                          ),
                          Text('FAQs :', style: TextStyle(color: primaryColor)),
                          Text(
                            'Frequently asked questions',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Faq()),
                    );
                  },
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(1, 10))
                      ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: primaryColor,
                            size: 50,
                          ),
                          Text('Locate to us :',
                              style: TextStyle(color: primaryColor)),
                          Text(
                            'Find us on Google Maps',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapLoaction()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text('Copyright (c) 2021 Rent O Integrated'),
            Text('All rights reserved')
          ],
        ),
      ),
    );
  }
}
