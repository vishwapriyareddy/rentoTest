import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:roi_test/constants.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getSliderImageFromDb() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getSliderImageFromDb(),
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                      imageUrl: getImage!['image'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => GFShimmer(
                                          showShimmerEffect: true,
                                          mainColor: Colors.grey.shade400,
                                          secondaryColor: Colors.grey.shade200,
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ))),
                                ),
                              ));
                        },
                        options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            height: 200,
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
                activeColor: cyan.withOpacity(0.8),
              ),
            )
        ],
      ),
    );
  }
}
