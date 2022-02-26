import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/order_provider.dart';

import 'package:roi_test/screens/payment/razorpayment_screen.dart';

class PaymentHomePage extends StatefulWidget {
  static const String id = 'payment-home-page';

  const PaymentHomePage({Key? key}) : super(key: key);

  @override
  PaymentHomePageState createState() => PaymentHomePageState();
}

class PaymentHomePageState extends State<PaymentHomePage> {
  //final _paymentItems = <PaymentItem>[];
  // void onGooglePayResult(paymentResult) {
  //   print(paymentResult);
  // }
  // onItemPress(BuildContext context, int index) async {
  //   switch (index) {
  //     case 0:
  //       payViaNewCard(context);
  //       break;
  //     case 1:
  //       Navigator.pushNamed(context, ExistingCardsPage.id);
  //       break;
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<OrderProvider>(context);
    // _paymentItems.add(PaymentItem(
    //   label: 'Total',
    //   amount: _orderProvider.amount.toString(),
    //   status: PaymentItemStatus.final_price,
    // ));
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment", style: TextStyle(color: Colors.white)),
          backgroundColor: cyan.withOpacity(0.8),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 4,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child:
                        Image.asset("images/razorPay.png", fit: BoxFit.contain),
                  )),
            ),
            Text(
              'Total Amount to pay: ${_orderProvider.amount}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8, left: 40, right: 40),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RazorPaymentScreen.id);
                      },
                      child: Text('Proceed Payment...'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            //   Container(
            //     padding: EdgeInsets.all(20),
            //     child: ListView(
            //       shrinkWrap: true,
            //       children: <Widget>[
            //         ListTile(
            //             leading: Icon(
            //               Icons.add_circle,
            //               color: Theme.of(context).primaryColor,
            //             ),
            //             title: Text("Pay via new Card "),
            //             onTap: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(builder: (context) => AddCard()),
            //               );
            //             }),
            //         Divider(
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         ListTile(
            //             leading: Icon(
            //               Icons.credit_card,
            //               color: Theme.of(context).primaryColor,
            //             ),
            //             title: Text("Pay via existing Card "),
            //             onTap: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => ExistingCardsPage()),
            //               );
            //             })
            //       ],
            //     ),
            //     // padding: EdgeInsets.all(20),
            //     //   child: ListView.separated(
            //     //     shrinkWrap: true,
            //     //     itemBuilder: (context, index) {
            //     //   final Icon icon;
            //     //   final Text text;

            //     //       switch (index) {
            //     //         case 0:
            //     //           icon = Icon(
            //     //             Icons.add_circle,
            //     //             color: Theme.of(context).primaryColor,
            //     //           );
            //     //           text = Text("Pay via new Card ");
            //     //           break;
            //     //         case 1:
            //     //           icon = Icon(
            //     //             Icons.credit_card,
            //     //             color: primaryColor,
            //     //           );
            //     //           text = Text("Pay via existing Card ");
            //     //           break;
            //     //       }

            //     //       return InkWell(
            //     //         onTap: () {
            //     //           onItemPress(context, index);
            //     //         },
            //     //         child: ListTile(
            //     // title:  text,
            //     //           leading: icon,
            //     //         ),
            //     //       );
            //     //     },
            //     //     separatorBuilder: (context, index) => Divider(
            //     //       color: primaryColor,
            //     //     ),
            //     //     itemCount: 2,
            //     //   ),
            //   ),
          ],
        ));
  }
}
