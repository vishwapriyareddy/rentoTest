import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:roi_test/colors.dart';
import '../constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final _controller = PageController(
  initialPage: 0,
);
int _currentPage = 0;
List<Widget> _pages = [
  Column(
    children: [
      Expanded(flex: 1, child: Image.asset('images/location.png')),
      Text(
        'Set Your Delivery Location',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      )
    ],
  ),
  Column(
    children: [
      Expanded(flex: 1, child: Image.asset('images/housekeeping.png')),
      Text(
        'Services that matter',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      )
    ],
  ),
  Column(
    children: [
      Expanded(flex: 1, child: Image.asset('images/RO.png')),
      Text(
        'Services that matter',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      )
    ],
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              activeColor: primaryColor),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
