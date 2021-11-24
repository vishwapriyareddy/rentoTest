import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/splash.png',
                    width: deviceWidth(context) * 0.2,
                    height: deviceHeight(context) * 0.2,
                  )),
              TextField(),
              TextField(),
              TextField(),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
