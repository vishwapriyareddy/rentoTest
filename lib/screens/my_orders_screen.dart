import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/order_provider.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/network/network_status.dart';
import 'package:roi_test/services/order_service.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

class MyOrders extends StatefulWidget {
  static const String id = 'order-screen';
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser!;
  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'On the Way',
    'Start Service',
    'Service Completed',
  ];
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
            child: Text('Go to home'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return NetworkSensitive(
      child: WillPopScope(
        onWillPop: () {
          onback();
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: cyan.withOpacity(0.8),
              title: Text(
                'My Orders',
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: MainScreen.id),
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
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       CupertinoIcons.search,
              //       color: Colors.white,
              //     ),
              //     onPressed: () {},
              //   )
              //],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      width: MediaQuery.of(context).size.width,
                      child: ChipsChoice<int>.single(
                        value: tag,
                        onChanged: (val) {
                          if (val == 0) {
                            setState(() {
                              _orderProvider.status = null;
                            });
                          }
                          setState(() {
                            tag = val;
                            if (tag > 0) {
                              _orderProvider.status = options[val];
                            }
                          });
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: options,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                        choiceStyle: C2ChoiceStyle(
                          color: Colors.green,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _orderServices.orders
                            .where(
                              'userId',
                              isEqualTo: user.uid,
                            )
                            .where('orderStatus',
                                isEqualTo:
                                    tag > 0 ? _orderProvider.status : null)
                            // .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.data!.size == 0) {
                            //TODO: No Orders screen
                            return Center(
                                child: Text(tag > 0
                                    ? 'No ${options[tag]} orders'
                                    : 'No Orders,Continue Booking..'));
                          }

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          horizontalTitleGap: 0,
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 14,
                                            child: _orderServices
                                                .statusIcon(document),
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              document.get('orderStatus'),
                                              style: TextStyle(
                                                  color: _orderServices
                                                      .statusColor(document),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'On ${DateFormat.yMMMd().format(DateTime.parse(document.get('timestamp')))}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                  'Service Date: ${DateFormat.yMMMd().format(DateTime.parse(document.get('pickdate')))}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //_orderProvider.success == true
                                              Text(
                                                'Payment : Paid Online',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),

                                              Text(
                                                'Amount : ${document.get('total').toStringAsFixed(0)} Rupees',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (document
                                                .get('serviceProvider')['name']
                                                .length >
                                            2)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: ListTile(
                                                tileColor: Color(0xFF3c5784)
                                                    .withOpacity(.2),
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Image.network(
                                                    document.get(
                                                            'serviceProvider')[
                                                        'image'],
                                                    height: 24,
                                                  ),
                                                ),
                                                title: Text(
                                                    document.get(
                                                            'serviceProvider')[
                                                        'name'],
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                subtitle: Text(
                                                    _orderServices
                                                        .statusComment(
                                                            document),
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ),
                                            ),
                                          ),
                                        ExpansionTile(
                                          title: Text(
                                            'Order details',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                          subtitle: Text('View Order Details',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        // backgroundColor: Colors.white,
                                                        child: Image.network(
                                                            document.get(
                                                                        'serviceBookings')[
                                                                    index][
                                                                'serviceImage'])),
                                                    title: Text(
                                                      document.get(
                                                              'serviceBookings')[
                                                          index]['serviceName'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                    subtitle: Text(
                                                      '${document.get('serviceBookings')[index]['price'].toString()}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: document
                                                  .get('serviceBookings')
                                                  .length,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 12,
                                                  top: 8,
                                                  bottom: 8),
                                              child: Card(
                                                child: Column(
                                                  children: [
                                                    Row(children: [
                                                      Text('Service : ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      Text(
                                                          document.get(
                                                                  'supervoisor')[
                                                              'serviceName'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ])
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (document.get('orderStatus') ==
                                            'Service Completed')
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: InkWell(
                                              child: Text(
                                                'Rate Us',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: cyan,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onTap: () {
                                                show(document);
                                              },
                                            ),
                                          ),
                                        Divider(
                                          height: 3,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> show(DocumentSnapshot document) async {
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
                _orderServices
                    .updateOrderStatus(document.id, rating, comment)
                    .then((value) {
                  EasyLoading.showSuccess('Updated successfully');
                  // _auth.updateUserRatings(
                  //     id: user.uid, star: rating.toDouble(), comments: comment);
                });
              });
        });
  }
}
