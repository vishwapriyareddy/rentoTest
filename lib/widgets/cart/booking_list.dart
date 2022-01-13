import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roi_test/services/cart_services.dart';
import 'package:roi_test/widgets/cart/booking_card.dart';

class CartList extends StatefulWidget {
  final DocumentSnapshot document;

  const CartList({Key? key, required this.document}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartServices _cart = CartServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cart.cart.doc(_cart.user.uid).collection('services').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                direction: Axis.horizontal,
                //padding: EdgeInsets.zero,
                //shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  //ListTile(
                  //   title: Text(data['serviceName']),
                  //   subtitle: Text(data['mainServiceName']),
                  // );
                  return CartCard(document: document);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
