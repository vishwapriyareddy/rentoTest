import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Services {
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');
  getTopPickedService() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('servicename')
        .snapshots();
  }

  getAllService() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .orderBy('servicename')
        .snapshots();
  }

  getStoreServices() {}
}
