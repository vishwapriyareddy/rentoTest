import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/services/services.dart';

class VenndorBanner extends StatefulWidget {
  const VenndorBanner({Key? key}) : super(key: key);

  @override
  _VenndorBannerState createState() => _VenndorBannerState();
}

class _VenndorBannerState extends State<VenndorBanner> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void didChangeDependencies() {
    var _servicStore = Provider.of<ServiceStore>(context);

    getBannerImageFromDb(_servicStore);
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getBannerImageFromDb(ServiceStore servicStore) async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection('vendorBanner')
        .where('supervisorUid', isEqualTo: servicStore.serviceDetails!['uid'])
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
    var _servicStore = Provider.of<ServiceStore>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getBannerImageFromDb(_servicStore),
              builder: (_,
                  AsyncSnapshot<
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>>
                      snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index, int) {
                          DocumentSnapshot<Map<String, dynamic>> sliderImage =
                              snapshot.data![index];
                          Map<String, dynamic>? getImage = sliderImage.data();
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                                imageUrl: getImage!['imageUrl'],
                                fit: BoxFit.contain,
                                placeholder: (context, url) => GFShimmer(
                                    showShimmerEffect: true,
                                    mainColor: Colors.grey.shade400,
                                    secondaryColor: Colors.grey.shade200,
                                    child: Container(
                                      color: Colors.grey.shade300,
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                    ))),
                          );
                        },
                        options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            height: 180,
                            onPageChanged: (int i, carouselPageChangedReason) {
                              setState(() {
                                _index = i;
                              });
                            })),
                  );
                }
              },
            ),
          if (_dataLength != 0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(5.0),
                  activeSize: const Size(18.0, 5.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  activeColor: Theme.of(context).primaryColor),
            )
        ],
      ),
    );
  }
}
