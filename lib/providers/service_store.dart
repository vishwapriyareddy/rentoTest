import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ServiceStore with ChangeNotifier {
  DocumentSnapshot? serviceDetails;
  String? selectedServiceCategory;
    String? selectedSubCategory;

  getSelectedServiceStore(serviceDetails) {
    this.serviceDetails = serviceDetails;
    notifyListeners();
  }

  getSelectedServiceCategory(category) {
    this.selectedServiceCategory = category;
    notifyListeners();
  }
   getSelectedServiceCategorySub(subCategory) {
    this.selectedSubCategory = subCategory;
    notifyListeners();
  }
}
