import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/models/service_model.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/screens/product_details_screen.dart';
import 'package:roi_test/widgets/cart/booking.dart';
import 'package:roi_test/widgets/search_card.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorAppBar extends StatefulWidget {
  const VendorAppBar({Key? key}) : super(key: key);

  @override
  State<VendorAppBar> createState() => _VendorAppBarState();
}

class _VendorAppBarState extends State<VendorAppBar> {
  static List<ServiceModel> services = [];
  String? offer;
  String? servicename;
  DocumentSnapshot? document;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('services')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          document = doc;
          offer = ((doc.get('comparedPrice') - doc.get('price')) /
                  doc.get('comparedPrice') *
                  100)
              .toStringAsFixed(0);
          services.add(ServiceModel(
              price: doc['price'],
              comparedPrice: doc['comparedPrice'],
              category: doc['category']['mainCategory'],
              image: doc['serviceImage'],
              serviceName: doc['serviceName'],
              service: doc['supervoisor']['servicename'],
              document: doc));
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  void dispose() {
    services.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _servicStore = Provider.of<ServiceStore>(context);

    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      snap: true,
      //pinned: true,
      backgroundColor: cyan.withOpacity(0.8),
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: SizedBox(
        // height: 150,
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                // height: 60,
                width: MediaQuery.of(context).size.width,
                // decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(4),
                // image: DecorationImage(
                //     fit: BoxFit.fill,
                //     image: NetworkImage(
                //         _servicStore.serviceDetails!['imageUrl']))
                //),
                child: Container(
                  //     height: 80,
                  color: Colors.white.withOpacity(.7),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _servicStore.serviceDetails!['dialog'],
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                child: IconButton(
                                  onPressed: () {
                                    launch(
                                        'tel:${_servicStore.serviceDetails!['mobile']}');
                                  },
                                  icon: Icon(Icons.phone),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star_half,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star_outline,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('(3.5)'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                servicename = _servicStore.serviceDetails!['servicename'];
              });
              showSearch(
                context: context,
                delegate: SearchPage<ServiceModel>(
                  onQueryUpdate: (s) => print(s),
                  items: services,
                  searchLabel: 'Search service',
                  suggestion: Center(
                    child: Text('Filter Service by name, Category or price'),
                  ),
                  failure: Center(
                    child: Text('No service found :('),
                  ),
                  filter: (services) => [
                    services.price.toString(),
                    services.category,
                    services.serviceName
                  ],
                  builder: (services) => servicename != services.service
                      ? Container()
                      : SearchCard(
                          offer: offer,
                          document: services.document,
                          services: services,
                        ),
                ),
              );
            },
            icon: Icon(CupertinoIcons.search))
      ],
      title: Text(
        _servicStore.serviceDetails!['servicename'],
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
