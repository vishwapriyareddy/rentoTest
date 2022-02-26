import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  String? status;
  String? amount;
  bool success = false;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }

  totalAmount(amount) {
    this.amount = amount.toStringAsFixed(0);
    notifyListeners();
  }

  paymentStatus(success) {
    this.success = success;
    notifyListeners();
  }
}
