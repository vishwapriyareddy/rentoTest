import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roi_test/models/product_display.dart';
import 'package:roi_test/services/order_service.dart';
import 'package:roi_test/widgets/products/bottom_sheet_container.dart';

class ProductDetailsScreen extends StatefulWidget {
  final DocumentSnapshot document;
  static const String id = 'productdetails-screen';
  ProductDetailsScreen({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    var offer =
        ((widget.document.get('comparedPrice') - widget.document.get('price')) /
            widget.document.get('comparedPrice') *
            100);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff09A3B8),
        iconTheme: IconThemeData(color: Colors.white),
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
        // ],
      ),
      bottomSheet: BottomSheetContainer(document: widget.document),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              widget.document.get('serviceName'),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Image.asset(
                    'images/rupee.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                Text(
                  '${widget.document.get('price').toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 2),
                  child: Image.asset(
                    'images/rupee.png',
                    fit: BoxFit.contain,
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                if (offer > 0)
                  Text(
                    '${widget.document.get('comparedPrice').toStringAsFixed(0)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (offer > 0)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(2)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text('${offer.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12)),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Hero(
                tag: 'service${widget.document.get('serviceName')}',
                child: CachedNetworkImage(
                    imageUrl: widget.document.get('serviceImage'),
                    placeholder: (context, url) => GFShimmer(
                        showShimmerEffect: true,
                        mainColor: Colors.grey.shade300,
                        secondaryColor: Colors.grey.shade200,
                        child: Container(
                          color: Colors.grey.shade300,
                          // height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                        ))),
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 6,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'About this service',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              child: ExpandableText(
                widget.document.get('description'),
                style: TextStyle(color: Colors.grey),
                expandText: 'View more',
                collapseText: 'View less',
                maxLines: 3,
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Text(
              "Customer Reviews",
              // style: TextStyle(fontSize: 25,color: Colors.white),
              style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _orderServices.orders
                      .where('orderStatus', isEqualTo: 'Service Completed')
                      .where(
                        'star',
                        isGreaterThanOrEqualTo: 3,
                      )

                      //.orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.size == 0) {
                      //TODO: No Orders screen
                      return Center(child: Text('No Reviews'));
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            // var comment = data['comment'].toString().length > 2;

                            return Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    horizontalTitleGap: 0,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 14,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    title: Row(
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
                                          document.get('star') == 4 ||
                                                  document.get('star') == 5
                                              ? Icons.star
                                              : Icons.star_outline,
                                          color: Colors.yellow,
                                        ),
                                        Icon(
                                          document.get('star') == 5
                                              ? Icons.star
                                              : Icons.star_outline,
                                          color: Colors.yellow,
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              document
                                                          .get('comment')
                                                          .toString()
                                                          .length >
                                                      2
                                                  ? document.get('comment')
                                                  : 'No Comments',
                                              style: TextStyle(
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
