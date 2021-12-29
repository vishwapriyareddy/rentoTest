import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:roi_test/services/cart_services.dart';

class BookingForCard extends StatefulWidget {
  final DocumentSnapshot document;
  const BookingForCard({Key? key, required this.document}) : super(key: key);

  @override
  State<BookingForCard> createState() => _BookingForCardState();
}

class _BookingForCardState extends State<BookingForCard> {
  CartServices _cart = CartServices();
  User user = FirebaseAuth.instance.currentUser!;
  bool _exist = false;
  String? _docId;
  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('services')
        .where('serviceId', isEqualTo: widget.document.get('serviceId'))
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.isNotEmpty)
                {
                  querySnapshot.docs.forEach((doc) {
                    if (doc['serviceId'] == widget.document.get('serviceId')) {
                      setState(() {
                        _exist = true;
                        _docId = doc.id;
                      });
                    }
                  }),
                }
              else
                {
                  setState(() {
                    _exist = false;
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return _exist
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.circular(4)),
                height: 28,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        EasyLoading.show(status: 'Deleting..');
                        _cart.removeFromCart(_docId).then((value) {
                          setState(() {
                            _exist = false;
                          });
                          EasyLoading.showSuccess('Deleted service');
                          _cart.checkData();
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Icon(Icons.delete_outline, color: Colors.pink),
                        ),
                      ),
                    ),
                    Container(
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.red)),
                      color: Colors.pink, width: 60, height: double.infinity,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            'Selected',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return InkWell(
                onTap: () {
                  EasyLoading.show(status: 'Adding to cart');
                  _cart.addToCart(widget.document).then((value) {
                    setState(() {
                      _exist = true;
                    });
                    EasyLoading.showSuccess('Added to cart');
                  });
                },
                child: Container(
                    height: 28,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              );
            });
  }
}
