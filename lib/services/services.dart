import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Services {
  getTopPickedService() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('servicename')
        .snapshots();
  }
}
