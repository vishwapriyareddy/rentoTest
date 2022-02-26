// //import 'dart:js';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:roi_test/screens/my_orders_screen.dart';

// class NotificationService extends ChangeNotifier {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   doSomething(context) {
//     return Navigator.pushReplacementNamed(context, MyOrders.id);
//   }

//   Future initialize() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("ic_launcher");
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: doSomething(BuildContext));
//   }

// //instant notifications
//   Future instantNotification() async {
//     var android = AndroidNotificationDetails(
//       "id",
//       "channel",
//     );
//     var platform = new NotificationDetails(android: android);
//     await _flutterLocalNotificationsPlugin.show(
//         0, "Your order is Placed", "Go to my orders", platform,
//         payload: "Welcome to ROI app");
//   }
// }
