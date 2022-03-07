//import 'dart:html';

// ignore_for_file: sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/screens/vendor_home_screen.dart';
import 'package:roi_test/services/services.dart';

class TopPickService extends StatefulWidget {
  const TopPickService({Key? key}) : super(key: key);

  @override
  State<TopPickService> createState() => _TopPickServiceState();
}

class _TopPickServiceState extends State<TopPickService> {
  final Services _services = Services();

  @override
  Widget build(BuildContext context) {
    final _serviceStore = Provider.of<ServiceStore>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: _services.getTopPickedService(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                SizedBox(
                    height: 30,
                    child: Image.asset('images/like.gif', color: Colors.green)),
                Text('Top Picks Services For You',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18))
              ]),
            ),
            Container(
              //  color: Colors.white,
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                // direction: Axis.horizontal,
                children: [
                  ...snapshot.data!.docs.map((DocumentSnapshot document) {
                    return InkWell(
                      onTap: () {
                        _serviceStore.getSelectedServiceStore(document);
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: VendorHomeScreen.id),
                          screen: VendorHomeScreen(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Card(
                                color: lightColor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                      imageUrl: document.get('imageUrl'),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => GFShimmer(
                                          showShimmerEffect: true,
                                          mainColor: Colors.grey.shade300,
                                          secondaryColor: Colors.grey.shade200,
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            height: 50,
                                            width: 50,
                                          ))),
                                ),
                              ),
                            ),
                            Container(
                              width: 92,
                              height: 40,
                              child: Text(
                                document.get('servicename'),
                                style: TextStyle(
                                  fontSize: 10, color: GFColors.FOCUS,
                                  // fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
