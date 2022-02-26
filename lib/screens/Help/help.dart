import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/screens/Help/contactUs.dart';

class Help extends StatefulWidget {
  static const String id = 'help';

  const Help({Key? key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  // void back() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => ProfileScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // => false,
        //   onWillPop: () async {
        //      Navigator.push(
        //    context,
        //    MaterialPageRoute(builder: (context) => HomeScreen()),
        //  );
//        back();
        Navigator.pop(context, true);
        return Future.value(true);
        //     // _moveToScreen2(context,);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Help"),
          backgroundColor: primaryColor,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              HelpMenu(
                icon: "images/contactus.svg",
                text: "Contact Us",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUs()),
                  );
                },
              ),
              // HelpMenu(
              //   icon: "images/ask.svg",
              //   text: "FAQ & Terms",
              //   press: () {},
              // ),
              HelpMenu(
                icon: "images/padlock.svg",
                text: "Privacy Policy",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

//   void _moveToScreen2(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     );
//   }
}

class HelpMenu extends StatelessWidget {
  const HelpMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final String text;
  final String icon;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5,
        child: FlatButton(
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            color: Color(0xFFF5F6F9),
            onPressed: press,
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 22,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                )),
                Icon(
                  Icons.arrow_forward,
                  color: primaryColor,
                )
              ],
            )),
      ),
    );
  }
}
