import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:roi_test/services/cart_services.dart';

class CartProvider with ChangeNotifier {
  // DocumentSnapshot? document;

  double subTotal = 0.0;
  QuerySnapshot? snapshot;
  int cartQty = 0;
  CartServices _cart = CartServices();
  Future<double?> getCartTotal() async {
    var cartTotal = 0.0;
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user.uid).collection('services').get();
    if (snapshot == null) {
      return null;
    }
    snapshot.docs.forEach((doc) {
      cartTotal = cartTotal + doc.get('total');
    });
    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    //this.document = document;
    notifyListeners();
    return cartTotal;
  }
}
