import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/my_orders_screen.dart';

class PaymentFailed extends StatefulWidget {
  static const String id = 'payment-failed';
  const PaymentFailed({Key? key}) : super(key: key);

  @override
  State<PaymentFailed> createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> {
  void onback() {
    AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: MainScreen.id),
                screen: MainScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Text('Try again Later'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onback();
        return Future.value(false);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 44,
              ),
              Text(
                'Payment Failed',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: MainScreen.id),
                      screen: MainScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Try again Later',
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
