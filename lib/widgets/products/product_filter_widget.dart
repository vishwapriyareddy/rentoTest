import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/services/product_services.dart';

class ProductFilterWidget extends StatefulWidget {
  const ProductFilterWidget({Key? key}) : super(key: key);

  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  ProductServices _services = ProductServices();
  @override
  void didChangeDependencies() {
    var _store = Provider.of<ServiceStore>(context);
    FirebaseFirestore.instance
        .collection('services')
        .where('category.mainCategory',
            isEqualTo: _store.selectedServiceCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _subCatList.add(doc['category']['subCategory']);
        });
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeData = Provider.of<ServiceStore>(context);
    return FutureBuilder<DocumentSnapshot>(
        future:
            _services.category.doc(_storeData.selectedServiceCategory).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return Container();
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
              height: 50,
              color: Colors.grey,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  ActionChip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    elevation: 4,
                    label: Text('All ${_storeData.selectedServiceCategory}'),
                    onPressed: () {
                      _storeData.getSelectedServiceCategorySub(null);
                    },
                    backgroundColor: Colors.white,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child:
                            _subCatList.contains(data['subCat'][index]['name'])
                                ? ActionChip(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    elevation: 4,
                                    label: Text(data['subCat'][index]['name']),
                                    onPressed: () {
                                      _storeData.getSelectedServiceCategorySub(
                                          data['subCat'][index]['name']);
                                    },
                                    backgroundColor: Colors.white,
                                  )
                                : Container(),
                      );
                    },
                    itemCount: data.length,
                  )
                ],
              ));
        });
  }
}
