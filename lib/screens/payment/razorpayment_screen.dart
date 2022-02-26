import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/cart_provider.dart';
import 'package:roi_test/providers/order_provider.dart';
import 'package:roi_test/screens/cart_screen.dart';
import 'package:roi_test/screens/my_orders_screen.dart';
import 'package:roi_test/screens/payment/payment_failed.dart';
import 'package:roi_test/services/cart_services.dart';
import 'package:roi_test/services/order_service.dart';
//import 'package:roi_test/services/notifications.dart';

//void main() => runApp(MyApp());

class RazorPaymentScreen extends StatefulWidget {
  static const String id = 'razor-pay';
  @override
  _RazorPaymentScreenState createState() => _RazorPaymentScreenState();
}

class _RazorPaymentScreenState extends State<RazorPaymentScreen> {
  // static const platform = const MethodChannel("razorpay_flutter");

  //final CartScreen _cartScreen = CartScreen(document: document);
  late Razorpay _razorpay;
  bool? success;
  @override
  void initState() {
    //  Provider.of<NotificationService>(context, listen: false).initialize();
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> openCheckout(OrderProvider orderProvider) async {
    User user = FirebaseAuth.instance.currentUser!;
    //PaymentSuccessResponse? response;
    // var options = {
    //   'key': 'rzp_live_bD4Qnb5JnSbQOZ',
    //   'amount': '${orderProvider.amount}00',
    //   'name': 'Rent O Integrated',
    //   'description': 'Services that matter',
    //   'retry': {'enabled': true, 'max_count': 1},
    //   'send_sms_hash': true,
    //   'prefill': {
    //     'contact': user.phoneNumber,
    //   },
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };
    var orderOptions = {
      'amount':
          '${orderProvider.amount}00', // amount in the smallest currency unit
      'currency': "INR",
      'receipt': "order_rcptid_11"
    };
    final client = HttpClient();
    final request =
        await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode(
            '${'rzp_live_bD4Qnb5JnSbQOZ'}:${'ES4Q94p04yxgV3zmsLRGHHIZ'}'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(json.encode(orderOptions)));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print('ORDERID' + contents);
      String orderId = contents.split(',')[0].split(":")[1];
      orderId = orderId.substring(1, orderId.length - 1);
      Fluttertoast.showToast(
          msg: "ORDERID: " + orderId, toastLength: Toast.LENGTH_SHORT);
      Map<String, dynamic> checkoutOptions = {
        'key': 'rzp_live_bD4Qnb5JnSbQOZ',
        'amount': '${orderProvider.amount}00',
        'name': 'Rent O Integrated',
        'description': 'Services that matter',
        'order_id': orderId,
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {
          'contact': user.phoneNumber,
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorpay.open(checkoutOptions);
        // if (response!.paymentId != null) {setState((){orderProvider(true);});}
      } catch (e) {
        debugPrint('Error: e');
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      success = true;
      //  final _orderProvider = Provider.of<OrderProvider>(context, listen: true);
      //_orderProvider.paymentStatus(true);
    });

    EasyLoading.showSuccess("SUCCESS PAYMENT: " + response.paymentId!);
    // EasyLoading.dismiss();

    Navigator.pushNamed(context, MyOrders.id);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.showError("ERROR: Try Again Later"
        // response.code.toString() +
        // " - " +
        // response.message!,
        );
    EasyLoading.dismiss();
    // Navigator.pop(context);
    //Navigator.pop(context);
    Navigator.pushNamed(context, PaymentFailed.id);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    EasyLoading.show(
      status: "EXTERNAL_WALLET: " + response.walletName!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(
      context,
    );

    // var _payable = _cartProvider.subTotal;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cyan.withOpacity(0.8),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Payment using Razorpay',
            style: TextStyle(color: Colors.white)),
      ),
      body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Amount to pay: ${orderProvider.amount}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //   Consumer<NotificationService>(builder: (context, model, _) {
                ElevatedButton(
                  onPressed: () {
                    openCheckout(orderProvider).whenComplete(() {
                      //if (success == true) {
                      // setState(() {
                      //  orderProvider.paymentStatus(true);

                      // });

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);

                      //Navigator.pushNamed(context, MyOrders.id);

                      //model.instantNotification();
                      //}
                    });
                  },
                  child: Text('Continue'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                )
                //              }),
              ],
            )
          ])),
    );
  }

  // _saveOrder(
  //     CartProvider cartProvider,
  //     payable,
  //     DateTime picked,
  //     OrderServices _orderServices,
  //     CartServices _cartServices,
  //     DocumentSnapshot document) {
  //   _orderServices.saveOrder({
  //     'serviceBookings': cartProvider.cartList,
  //     'userId': user.uid,
  //     //'userLocation': GeoPoint(_userLatitude, _userLongitude),
  //     'total': payable,
  //     'supervoisor': {
  //       'serviceName': widget.document.get('serviceName'),
  //       'supervisorUid': widget.document.get('supervisorUid'),
  //     },
  //     'timestamp': DateTime.now().toString(),
  //     'pickdate': picked.toString(),
  //     'orderStatus': 'Ordered',
  //     'serviceProvider': {
  //       'name': '',
  //       'phone': '',
  //       'location': '',
  //       'image': '',
  //       'email': ''
  //     } //deliveryBoy
  //   })!.then((value) {
  //     // after submitting order we need to clear cart
  //     _cartServices.deleteCart().then((value) {
  //       _cartServices.checkData().then((value) {
  //         EasyLoading.showSuccess('Your order is submitted');
  //         // Navigator.of(context).pop();
  //       });
  //     });
  //   });
  // }
}
