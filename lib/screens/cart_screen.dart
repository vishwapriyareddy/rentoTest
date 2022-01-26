//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/cart_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/payment/payment_home.dart';
import 'package:roi_test/screens/profile_screen.dart';
import 'package:roi_test/services/cart_services.dart';
import 'package:roi_test/services/order_service.dart';
import 'package:roi_test/services/user_services.dart';
import 'package:roi_test/widgets/cart/booking_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final DocumentSnapshot document;
  static const String id = 'cart-screen';
  const CartScreen({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DateTime selectedDate = new DateTime.now().add(new Duration(days: 1));

  var textStyle = TextStyle(color: Colors.grey);
  int discount = 30;
  String _address = '';
  UserServices _userService = UserServices();
  OrderServices _orderServices = OrderServices();
  CartServices _cartServices = CartServices();
  User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');

    setState(() {
      _address = address!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _dateController = TextEditingController();
    //final _dateCtl = TextEditingController();

    Future<Null> _selectDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: new DateTime.now().add(new Duration(days: 1)),
          //  firstDate: new DateTime.now().add(new Duration(days: 1)),
          lastDate: DateTime(2101),
          initialDatePickerMode: DatePickerMode.day,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData(
                primaryColor: primaryColor,
              ),
              child: child!,
            );
          });
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          _dateController.text = picked.toString();
        });
    }

    final locationData = Provider.of<LocationProvider>(context);
    final _cartProvider = Provider.of<CartProvider>(context);
    // var userDetails = Provider.of<AuthProvider>(context);
    var _payable = _cartProvider.subTotal;
    bool _loading = false;
    //  _cartProvider.document as DocumentSnapshot;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade200,
        bottomSheet: Container(
          height: 160,
          color: Colors.blueGrey[900],
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.only(bottom: 60),
                height: 100,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service to this Address: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _loading = true;
                              });
                              locationData.getCurrentPosition().then((value) {
                                setState(() {
                                  _loading = false;
                                });
                                if (value != null) {
                                  pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(name: MapScreen.id),
                                    screen: MapScreen(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  print('Permission not allowed');
                                }
                              });
                            },
                            child: _loading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Change',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Text(
                        '${_address}',
                        // maxLines: 3,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Image.asset(
                                'images/rupee.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                            Text(
                              '${_cartProvider.subTotal.toStringAsFixed(0)}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text(
                          '(Including Taxes)',
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        )
                      ],
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent)),
                        onPressed: () {
                          _userService.getUserById(user.uid).then((value) {
                            if (mounted) {
                              if (value.get('number') == null) {
                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings:
                                      RouteSettings(name: ProfileScreen.id),
                                  screen: ProfileScreen(),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              } else {
                                EasyLoading.show(status: 'Please wait...');
                                _saveOrder(
                                    _cartProvider, _payable, selectedDate);
                                // EasyLoading.showSuccess(
                                //     'Your Order is Submitted ');

                                // Navigator.pushNamed(
                                //       context, PaymentHomePage.id);
                              }
                            }
                          });
                        },
                        child: Text(
                          'CHECKOUT',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Color(0xFF3c5784),
                elevation: 0.0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(widget.document.toString()),
                    Text('Your Cart'),
                    Row(
                      children: [
                        Text(
                          '${_cartProvider.cartQty} | ${_cartProvider.cartQty == 1 ? 'service, ' : 'services, '}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        Text(
                          'To Pay: ${_cartProvider.subTotal.toStringAsFixed(0)} Rupees',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ];
          },
          body: _cartProvider.cartQty > 0
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  // physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 150),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 2, left: 8),
                            child: Text(
                              'Choose date of Service',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                                cursorColor: Color(0xFFC41A3B),
                                controller: _dateController,
                                onTap: () async {
                                  _selectDate(context);
                                  // FocusScope.of(context)
                                  //     .requestFocus(new FocusNode());
                                },
                                maxLines: 1,
                                //initialValue: 'Aseem Wangoo',
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 1) {
                                    return 'Choose Date';
                                  }
                                },
                                onSaved: (value) {
                                  _dateController.text = value.toString();
                                  print('${_dateController.text}');
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                    // labelText: 'Select Date',
                                    hintText: (selectedDate.toString()),
                                    contentPadding: EdgeInsets.all(8),
                                    icon: const Icon(Icons.calendar_today),
                                    //labelStyle: TextStyle(
                                    //fontSize: 16,
                                    //decorationStyle:
                                    //      TextDecorationStyle.solid),
                                    enabledBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    focusColor:
                                        Theme.of(context).primaryColor)),
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   controller: _dateCtl,
                          //   decoration: InputDecoration(
                          //       labelText: 'Date',
                          //       hintText: _dateCtl.toString()),
                          //   onTap: () async {
                          //     await showDatePicker(
                          //       context: context,
                          //       initialDate: new DateTime.now()
                          //           .add(new Duration(days: 1)),
                          //       firstDate: new DateTime.now()
                          //           .add(new Duration(days: 1)),
                          //       lastDate: DateTime(2025),
                          //     ).then((selectedDate) {
                          //       if (selectedDate != null) {
                          //         _dateCtl.text = DateFormat('yyyy-MM-dd')
                          //             .format(selectedDate);
                          //       }
                          //     });
                          //   },
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter date.';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            child: CartList(
                              document: widget.document,
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bill Details',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Basket Value',
                                        style: textStyle,
                                      ),
                                      Container(
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'images/rupee.png',
                                                    fit: BoxFit.contain,
                                                    color: Colors.black,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                  ),
                                                  Text(
                                                    '${_cartProvider.subTotal.toStringAsFixed(0)}',
                                                    style: textStyle,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Discount',
                                        style: textStyle,
                                      ),
                                      Container(
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    child: Image.asset(
                                                      'images/rupee.png',
                                                      fit: BoxFit.contain,
                                                      color: Colors.black,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_cartProvider.saving.toStringAsFixed(0)}',
                                                    style: textStyle,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    child: Image.asset(
                                                      'images/rupee.png',
                                                      fit: BoxFit.contain,
                                                      color: Colors.black,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_payable.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.3)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Saving',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Image.asset(
                                                          'images/rupee.png',
                                                          fit: BoxFit.contain,
                                                          color: Colors.blue,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${_cartProvider.saving.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text('Cart Empty, Continue Booking'),
                ),
        ));
  }

  _saveOrder(CartProvider cartProvider, payable, DateTime picked) {
    _orderServices.saveOrder({
      'serviceBookings': cartProvider.cartList,
      'userId': user.uid,
      'total': payable,
      'supervoisor': {
        'serviceName': widget.document.get('serviceName'),
        'supervisorUid': widget.document.get('supervisorUid'),
      },
      'timestamp': DateTime.now().toString(),
      'pickdate': picked.toString(),
      'orderStatus': 'Ordered',
      'serviceProvider': {'name': '', 'phone': '', 'location': ''} //deliveryBoy
    })!.then((value) {
      // after submitting order we need to clear cart
      _cartServices.deleteCart().then((value) {
        _cartServices.checkData().then((value) {
          EasyLoading.showSuccess('Your order is submitted');
          Navigator.of(context).pop();
        });
      });
    });
  }
}
