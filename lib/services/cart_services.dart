import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser!;
  Future<void> addToCart(document) {
    cart.doc(user.uid).set({
      'user': user.uid,
      'supervisorUid': document.data()['supervoisor']['supervisorUid'],
      'serviceName': document.data()['supervoisor']['servicename']
    });
    return cart.doc(user.uid).collection('services').add({
      'serviceId': document.data()['serviceId'],
      'serviceName': document.data()['serviceName'],
      'serviceImage': document.data()['serviceImage'],
      'price': document.data()['price'],
      'comparedPrice': document.data()['comparedPrice'],
      'qty': 1,
      'supervisorUid': document.data()['supervoisor']['supervisorUid'],
      'mainServiceName': document.data()['supervoisor']['servicename'],
      'total': document.data()['price'],
    });
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user.uid).collection('services').doc(docId).delete();
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user.uid).collection('services').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user.uid).delete();
    }
  }

  Future<String?> checkSupervisor() async {
    final snapshot = await cart.doc(user.uid).get();
    return snapshot.exists ? snapshot.get('serviceName') : null;
  }

  Future<void> deleteCart() async {
    final result =
        await cart.doc(user.uid).collection('services').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
