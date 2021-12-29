import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:roi_test/services/cart_services.dart';
import 'package:roi_test/widgets/cart/booking_widget.dart';

class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot document;
  const AddToCartWidget({Key? key, required this.document}) : super(key: key);

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  CartServices _cart = CartServices();
  User user = FirebaseAuth.instance.currentUser!;
  bool _loading = true;
  bool _exist = false;
  String? _docId;
  @override
  void initState() {
    getCartData(); // check cart item already in cart or not
    super.initState();
  }

  getCartData() async {
    final snapshot =
        await _cart.cart.doc(user.uid).collection('services').get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('services')
        .where('serviceId', isEqualTo: widget.document.get('serviceId'))
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc['serviceId'] == widget.document.get('serviceId')) {
                  setState(() {
                    _exist = true;
                    _docId = doc.id;
                  });
                }
              }),
            });
    return _loading
        ? Container(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          )
        : _exist
            ? BookingWidget(
                document: widget.document,
                docId: _docId.toString(),
              )
            : InkWell(
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
                    height: 56,
                    color: Colors.red[400],
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Add Service',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ))),
              );
  }
}
