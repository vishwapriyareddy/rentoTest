import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorAppBar extends StatelessWidget {
  const VendorAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _servicStore = Provider.of<ServiceStore>(context);

    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      snap: true,
      //pinned: true,
      backgroundColor: Color(0xFF3c5784),
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: SizedBox(
        // height: 150,
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                // height: 60,
                width: MediaQuery.of(context).size.width,
                // decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(4),
                // image: DecorationImage(
                //     fit: BoxFit.fill,
                //     image: NetworkImage(
                //         _servicStore.serviceDetails!['imageUrl']))
                //),
                child: Container(
                  //     height: 80,
                  color: Colors.white.withOpacity(.7),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _servicStore.serviceDetails!['dialog'],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: IconButton(
                                      onPressed: () {
                                        launch(
                                            'tel:${_servicStore.serviceDetails!['mobile']}');
                                      },
                                      icon: Icon(Icons.phone),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star_half,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star_outline,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('(3.5)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
      ],
      title: Text(
        _servicStore.serviceDetails!['servicename'],
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
