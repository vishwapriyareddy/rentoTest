import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/widgets/products/product_filter_widget.dart';
import 'package:roi_test/widgets/products/product_list_widget.dart';

import 'package:roi_test/widgets/vendorAppBar.dart';

class ProductList extends StatelessWidget {
  static const String id = 'product-list';
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<ServiceStore>(context);

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Color(0xFF3c5784),
                  title: Text(
                    _storeProvider.selectedServiceCategory!,
                    style: TextStyle(color: Colors.white),
                  ),
                  expandedHeight: 112,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(top: 88),
                    child: Container(
                      height: 56,
                      color: Colors.grey,
                      child: ProductFilterWidget(),
                    ),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                )
              ];
            },
            body: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                ProductListWidget(),
              ],
            )));
  }
}
