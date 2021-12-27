//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
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
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                SizedBox(
                    height: 30,
                    child: Image.asset('images/like.gif', color: Colors.green)),
                Text('Top Picks Services For You',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18))
              ]),
            ),
            Flexible(
              child: ListView(
                scrollDirection: Axis.horizontal,
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
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 20,
                                  color: Color(0xFFB0CCE1).withOpacity(0.32)),
                            ],
                            // borderRadius: BorderRadius.all(Radius.circular(2)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.32),
                              width: 0.1,
                            ),
                            // gradient: RadialGradient(colors: [
                            //   Colors.white,
                            //   primaryColor.withOpacity(0.32),
                            // ], radius: 0.95, focal: Alignment.center),
                          ),
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Card(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    document.get('imageUrl'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                              ),
                              Container(
                                child: Text(
                                  document.get('servicename'),
                                  style: TextStyle(
                                      fontSize: 12, color: primaryColor
                                      // fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
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
