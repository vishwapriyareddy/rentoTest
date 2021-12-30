import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roi_test/widgets/cart/booking.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot document;
  const CartCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double saving = document.get('comparedPrice') - document.get('price');
    return Container(
      height: 120,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          color: Colors.white),
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                height: 140,
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      document.get(
                        'serviceImage',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(document.get('serviceName')),
                    Row(
                      children: [
                        Text('Chosen From:',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text(document.get('mainServiceName'),
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (document.get('comparedPrice') > 0)
                      Text(
                        document.get('comparedPrice').toString(),
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12),
                      ),
                    Text(
                      document.get('price').toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              right: 0.0,
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BookingForCard(document: document),
              )),
          if (saving > 0)
            Positioned(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Image.asset(
                            'images/rupee.png',
                            fit: BoxFit.contain,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                        Text(
                          '${saving.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        ],
      ),
    );
  }
}
