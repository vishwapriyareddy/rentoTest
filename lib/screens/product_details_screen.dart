import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roi_test/models/product_display.dart';

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
  // final ProductDetails _details =
  @override
  Widget build(BuildContext context) {
    var offer =
        ((widget.document.get('comparedPrice') - widget.document.get('price')) /
            widget.document.get('comparedPrice') *
            100);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3c5784),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
        ],
      ),
      bottomSheet: Container(
        child: Row(
          children: [
            // Expanded(
            //     child: InkWell(
            //   onTap: () {
            //     saveForLater();
            //   },
            //   child: Container(
            //       height: 56,
            //       color: Colors.grey[800],
            //       child: Center(
            //           child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Icon(
            //               CupertinoIcons.bookmark,
            //               color: Colors.white,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text('Save for Later',
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold)),
            //           ],
            //         ),
            //       ))),
            // )),
            Expanded(
                child: Container(
                    height: 56,
                    color: Colors.red[400],
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Add Service',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )))),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          //  padding: EdgeInsets.zero,
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
                child: Image.network(
                  widget.document.get('serviceImage'),
                ),
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
            SizedBox(
              height: 90,
            )

            // Container(
            //     child: Text(
            //   'Other Service info',
            //   style: TextStyle(fontSize: 20),
            // )),
            // Divider(
            //   color: Colors.grey[400],
            // ),
          ],
        ),
      ),
    );
  }
}
