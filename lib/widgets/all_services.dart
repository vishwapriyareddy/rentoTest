import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/colors.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/screens/vendor_home_screen.dart';

class AllServices extends StatefulWidget {
  const AllServices({Key? key}) : super(key: key);

  @override
  _AllServicesState createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  int _dataLength = 1;

  @override
  void initState() {
    allServices();
    super.initState();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      allServices() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    final _serviceStore = Provider.of<ServiceStore>(context);

    return FutureBuilder(
      future: allServices(),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
              snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');
        if (_dataLength == 0) return CircularProgressIndicator();
        if (!snapshot.hasData) return Container();

        return SingleChildScrollView(
          child: Wrap(
            spacing: 2.0, // gap between adjacent chips
            runSpacing: 2.0,
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Text('All Services',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18))
                ]),
              ),
              ...snapshot.data!.map((DocumentSnapshot document) {
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
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      width: 90,
                      height: 100,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Container(
                                    //width:
                                    // MediaQuery.of(context).size.width * 0.07,
                                    //height:
                                    //MediaQuery.of(context).size.height * 0.1,
                                    //decoration: BoxDecoration(
                                    //borderRadius:
                                    //  BorderRadius.all(Radius.circular(10)),
                                    //shape: BoxShape.rectangle,
                                    // image: DecorationImage(
                                    //     image: NetworkImage(
                                    //       document.get('imageUrl'),
                                    //     ),
                                    //     fit: BoxFit.contain),
                                    child: Card(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CachedNetworkImage(
                                        imageUrl: document.get('imageUrl'),
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            GFShimmer(
                                                showShimmerEffect: true,
                                                mainColor: Colors.grey.shade300,
                                                secondaryColor:
                                                    Colors.grey.shade200,
                                                child: Container(
                                                  color: Colors.grey.shade300,
                                                  height: 40,
                                                  width: 40,
                                                ))),
                                  ),
                                )),
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 52,
                                  height: 40,
                                  child: Text(
                                    document.get('servicename'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          color: GFColors.FOCUS,
                                          fontSize: 8,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                  )),
                            ),
                            //SizedBox(
                            //height: 1.0,
                            //),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
