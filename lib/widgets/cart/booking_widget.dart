import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:roi_test/services/cart_services.dart';
import 'package:roi_test/widgets/products/add_to_cart_widget.dart';

class BookingWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final String docId;
  const BookingWidget({Key? key, required this.document, required this.docId})
      : super(key: key);

  @override
  _BookingWidgetState createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  CartServices _cart = CartServices();
  bool _exist = true;
  @override
  Widget build(BuildContext context) {
    return _exist
        ? Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 56,
            child: Center(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: FittedBox(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            EasyLoading.show(status: 'Deleting..');
                            _cart.removeFromCart(widget.docId).then((value) {
                              setState(() {
                                _exist = false;
                              });
                              EasyLoading.showSuccess('Deleted service');
                              _cart.checkData();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Icon(Icons.delete_outline, color: Colors.red),
                            ),
                          ),
                        ),
                        Container(
                          // decoration:
                          //     BoxDecoration(border: Border.all(color: Colors.red)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 8),
                            child: Text(
                              'Selected',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )
        : AddToCartWidget(document: widget.document);
  }
}
