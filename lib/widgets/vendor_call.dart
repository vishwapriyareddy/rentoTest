import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/providers/service_store.dart';

class VendorCall extends StatelessWidget {
  const VendorCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _servicStore = Provider.of<ServiceStore>(context);

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                // image: DecorationImage(
                //     fit: BoxFit.fill,
                //     image: NetworkImage(
                //         _servicStore.serviceDetails!['imageUrl']))
              ),
              child: Container(
                color: Colors.white.withOpacity(.7),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListView(
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
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
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
                          Text('(3.5)')
                        ],
                      ),
                      //   Row(
                      //     children: [
                      //       CircleAvatar(
                      //         backgroundColor: Theme.of(context).primaryColor,
                      //         child: Icon(
                      //           Icons.phone,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ],
                      //   )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
