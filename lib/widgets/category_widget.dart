//import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/screens/product_list.dart';

import 'package:roi_test/services/product_services.dart';

class VendorCategories extends StatefulWidget {
  const VendorCategories({Key? key}) : super(key: key);

  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  final ProductServices _services = ProductServices();
  final List _catList = [];
  @override
  void didChangeDependencies() {
    var _servicStore = Provider.of<ServiceStore>(context);
    FirebaseFirestore.instance
        .collection('services')
        .where('supervoisor.supervisorUid',
            isEqualTo: _servicStore.serviceDetails!['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc['category']['mainCategory']);
                setState(() {
                  _catList.add(doc['category']['mainCategory']);
                });
              })
            });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<ServiceStore>(context);
    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }
        if (_catList.length == 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
          child: Wrap(
            // padding: EdgeInsets.zero,
            //shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            direction: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return _catList.contains(document.get('name'))
                  ? InkWell(
                      onTap: () {
                        _storeProvider
                            .getSelectedServiceCategory(document.get('name'));
                        _storeProvider.getSelectedServiceCategorySub(null);

                        pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: ProductList.id),
                          screen: ProductList(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                        // print(document.get('name'));
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.all(4),
                        tileColor: Colors.white,
                        title: Row(
                          children: [
                            SizedBox(
                              height: 65,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                    imageUrl: document.get('image'),
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => GFShimmer(
                                        showShimmerEffect: true,
                                        mainColor: Colors.grey.shade300,
                                        secondaryColor: Colors.grey.shade200,
                                        child: Container(
                                          color: Colors.grey.shade300,
                                          height: 75,
                                          width: 110,
                                          // width: 120,
                                        ))
                                    // width: MediaQuery.of(context).size.width *
                                    //   0.5,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                document.get('name'),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        subtitle: Divider(
                          thickness: 1,
                        ),
                      ),
                    )
                  : Text('');
            }).toList(),
          ),
        );
      },
    );
  }
}
