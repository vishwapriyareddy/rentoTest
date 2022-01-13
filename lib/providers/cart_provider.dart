import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:roi_test/services/cart_services.dart';

class CartProvider with ChangeNotifier {
  DocumentSnapshot? document;

  double subTotal = 0.0;
  double saving = 0.0;
  List cartList = [];
  QuerySnapshot? snapshot;
  int cartQty = 0;
  CartServices _cart = CartServices();
  Future<double?> getCartTotal() async {
    var cartTotal = 0.0;
    var saving = 0.0;
    List _newList = [];
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user.uid).collection('services').get();
    if (snapshot == null) {
      return null;
    }
    snapshot.docs.forEach((doc) {
      if (!_newList.contains(doc.data())) {
        _newList.add(doc.data());
        this.cartList = _newList;
        notifyListeners();
      }
      cartTotal = cartTotal + doc.get('total');
      saving = saving +
          ((doc.get('comparedPrice') - doc.get('price')) > 0
              ? doc.get('comparedPrice') - doc.get('price')
              : 0);
    });
    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    this.saving = saving;
    notifyListeners();
    return cartTotal;
  }

  getServiName() async {
    DocumentSnapshot doc = await _cart.cart.doc(_cart.user.uid).get();
    if (doc.exists) {
      this.document = doc;
      notifyListeners();
    } else {
      this.document = null;
      notifyListeners();
    }
  }
}
