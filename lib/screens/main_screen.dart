import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/my_orders_screen.dart';
import 'package:roi_test/screens/profile_screen.dart';
import 'package:roi_test/widgets/cart/bookingcart_notification.dart';

class MainScreen extends StatelessWidget {
  // final DocumentSnapshot document;
  static const String id = 'main-screen';
  const MainScreen({
    Key? key,
    // required this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);
    // void onback() {
    //   AwesomeDialog(
    //     dialogBackgroundColor: white,
    //     context: context,
    //     dialogType: DialogType.WARNING,
    //     borderSide: BorderSide(color: white, width: 2),
    //     width: 350,
    //     buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    //     headerAnimationLoop: false,
    //     animType: AnimType.BOTTOMSLIDE,
    //     title: 'Exit',
    //     desc: 'Are sure you want to exit ?',
    //     buttonsTextStyle: TextStyle(fontSize: 12, color: primaryColor),
    //     showCloseIcon: true,
    //     btnCancelOnPress: () {
    //       Navigator.pushNamed(context, MainScreen.id);
    //     },
    //     btnOkOnPress: () {
    //       SystemNavigator.pop();
    //     },
    //   )..show();
    // }

    List<Widget> _buildScreens() {
      return [HomeScreen(), MyOrders(), ProfileScreen()];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColorPrimary: cyan,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.bag),
          title: ("My Orders"),
          activeColorPrimary: cyan,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("My Account"),
          activeColorPrimary: cyan,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: CartNotification(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PersistentTabView(
        context, navBarHeight: 56,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
            border: Border.all(color: Colors.black45)),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style4, // Choose the nav bar style with this property.
      ),
    );
  }
}
