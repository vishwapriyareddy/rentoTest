import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:roi_test/screens/product_details_screen.dart';
import 'package:roi_test/widgets/cart/booking.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;
  const ProductCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String offer = ((document.get('comparedPrice') - document.get('price')) /
            document.get('comparedPrice') *
            100)
        .toStringAsFixed(0);
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: ProductDetailsScreen.id),
                        screen: ProductDetailsScreen(
                          document: document,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: SizedBox(
                      height: 100,
                      width: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: 'service${document.get('serviceName')}',
                          child: CachedNetworkImage(
                              imageUrl: document.get('serviceImage'),
                              fit: BoxFit.contain,
                              placeholder: (context, url) => GFShimmer(
                                  showShimmerEffect: true,
                                  mainColor: Colors.grey.shade300,
                                  secondaryColor: Colors.grey.shade200,
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    height: 40,
                                    width: 40,
                                  ))),
                        ),
                      ),
                    ),
                  ),
                ),
                if (document.get('comparedPrice') > 0)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 3, bottom: 3, left: 10, right: 10),
                      child: Text(
                        '${offer}%OFF',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 8),
                            child: Text(document.get('serviceName'),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 6),
                          // Text('type',
                          //     style: TextStyle(
                          //         fontSize: 12,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.grey)),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Image.asset(
                                  'images/rupee.png',
                                  fit: BoxFit.contain,
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                              Text(
                                '${document.get('price').toStringAsFixed(0)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, top: 2),
                                child: Image.asset(
                                  'images/rupee.png',
                                  fit: BoxFit.contain,
                                  color: Colors.grey,
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                              ),
                              Text(
                                '${document.get('comparedPrice').toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BookingForCard(
                                document: document,
                              ),
                            ],
                          ),
                          // child: Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Card(
                          //       color: Colors.pink,
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 30.0, right: 30, top: 7, bottom: 7),
                          //         child: Text('ADD',
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.white)),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ),
                      ],
                    )
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
