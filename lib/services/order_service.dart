import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  Future<DocumentReference>? saveOrder(Map<String, dynamic> data) {
    var result = orders.add(data);
    return result;
  }

  Future<void> updateOrderStatus(documentId, star, comment) {
    var result =
        orders.doc(documentId).update({'star': star, 'comment': comment});
    return result;
  }

  Color? statusColor(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.get('orderStatus') == 'Rejected') {
      return Colors.red;
    }
    if (document.get('orderStatus') == 'On the Way') {
      return Colors.purple[900];
    }
    if (document.get('orderStatus') == 'Service Start') {
      return Colors.pink[900];
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon? statusIcon(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Rejected') {
      return Icon(
        Icons.assignment_late_outlined,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'On the Way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Service Start') {
      return Icon(
        Icons.sailing,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  String statusComment(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'On the Way') {
      return 'Your service provider ${document.get('serviceProvider')['name']} is on the way ';
    }
    if (document.get('orderStatus') == 'Service Start') {
      return 'Your service started by ${document.get('serviceProvider')['name']}';
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return 'Your service is now completed ';
    }
    return 'Your service provider ${document.get('serviceProvider')['name']} is on the way';
  }

  Widget? commentContainer(DocumentSnapshot document, context) {
    if (document.get('comment').toString().length > 1) {
      return document.get('comment') == null
          ? Container()
          : ListTile(
              // leading: CircleAvatar(
              //   backgroundColor: Colors.white,
              //   child: Image.network(document.get('serviceProvider')['image']),
              // ),
              title: Text(document.get('comment')),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            );
    }
    return Container();
  }
}
