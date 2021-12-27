import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/services/product_services.dart';
import 'package:roi_test/widgets/products/product_card_widget.dart';

class RecentlyAddedProduct extends StatelessWidget {
  const RecentlyAddedProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _serviceStore = Provider.of<ServiceStore>(context);

    return FutureBuilder<QuerySnapshot>(
      future: _services.services
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Recently Added')
          .where('supervoisor.supervisorUid',
              isEqualTo: _serviceStore.serviceDetails!['uid'])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 46,
                  decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      'Recently Added',
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3,
                              color: Colors.black)
                        ],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ProductCard(
                  document: document,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
