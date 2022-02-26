import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceModel {
  final String serviceName, category, image, service;
  final num price, comparedPrice;
  final DocumentSnapshot document;
  ServiceModel(
      {required this.serviceName,
      required this.category,
      required this.image,
      required this.price,
      required this.comparedPrice,
      required this.service,
      required this.document});
}
