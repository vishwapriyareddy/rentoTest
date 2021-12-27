import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/widgets/category_widget.dart';
import 'package:roi_test/widgets/my_appbar.dart';
import 'package:roi_test/widgets/products/best_selling_product.dart';
import 'package:roi_test/widgets/products/featured_product.dart';
import 'package:roi_test/widgets/products/recently_added.dart';
import 'package:roi_test/widgets/vendorAppBar.dart';
import 'package:roi_test/widgets/vendor_banner.dart';
import 'package:roi_test/widgets/vendor_call.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendorhome-screen';
  const VendorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _servicStore = Provider.of<ServiceStore>(context);

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [VendorAppBar()];
            },
            body: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  VenndorBanner(),
                  VendorCategories(),
                  RecentlyAddedProduct(),
                  FeaturedProduct(),
                  BestSellingProduct(),
                ])));
  }
}
