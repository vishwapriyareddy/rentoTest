import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:roi_test/services/services.dart';

class TopPickService extends StatefulWidget {
  const TopPickService({Key? key}) : super(key: key);

  @override
  _TopPickServiceState createState() => _TopPickServiceState();
}

class _TopPickServiceState extends State<TopPickService> {
  Services _services = Services();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _services.getTopPickedService(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Column(
          children: [
            Flexible(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: 80,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Card(
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  document['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              )),
                            ),
                            Container(
                              child: Text(
                                document['servicename'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
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
