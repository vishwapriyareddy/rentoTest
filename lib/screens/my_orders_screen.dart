import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/order_provider.dart';
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
    'On the way',
    'Service Completed',
  ];
  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Color(0xFF3c5784),
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
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
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _orderServices.orders
                      .where('userId', isEqualTo: user.uid)
                      .where('orderStatus',
                          isEqualTo: tag > 0 ? _orderProvider.status : null)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      child: Icon(
                                        CupertinoIcons.square_list,
                                        size: 18,
                                        color: document.get('orderStatus') ==
                                                'Rejected'
                                            ? Colors.red
                                            : document.get('orderStatus') ==
                                                    'Accepted'
                                                ? Colors.blueGrey[400]
                                                : Colors.orange,
                                      ),
                                    ),
                                    title: Text(
                                      document.get('orderStatus'),
                                      style: TextStyle(
                                          color: document.get('orderStatus') ==
                                                  'Rejected'
                                              ? Colors.red
                                              : document.get('orderStatus') ==
                                                      'Accepted'
                                                  ? Colors.blueGrey[400]
                                                  : Colors.orange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        'On ${DateFormat.yMMMd().format(DateTime.parse(document.get('timestamp')))}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Payment Type : Paid Online',
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
                                  ExpansionTile(
                                    title: Text(
                                      'Order details',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black),
                                    ),
                                    subtitle: Text('View Order Details',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  // backgroundColor: Colors.white,
                                                  child: Image.network(document
                                                          .get(
                                                              'serviceBookings')[
                                                      index]['serviceImage'])),
                                              title: Text(
                                                document.get('serviceBookings')[
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
                                                    document.get('supervoisor')[
                                                        'serviceName'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ])
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
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
    );
  }
}
