import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roi_test/colors.dart';

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
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    width: 85,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 20,
                              color: Color(0xFFB0CCE1).withOpacity(0.32))
                        ]),
                    // decoration: BoxDecoration(
                    //   // borderRadius: BorderRadius.all(Radius.circular(2)),
                    //   shape: BoxShape.rectangle,
                    //   border: Border.all(
                    //     color: Colors.black54,
                    //     width: 0.05,
                    //   ),
                    //   gradient: RadialGradient(colors: [
                    //     Colors.white,
                    //     primaryColor,
                    //   ], radius: 0.05, focal: Alignment.center),
                    // ),
                    // margin: EdgeInsets.all(0.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.07,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        document.get('imageUrl'),
                                      ),
                                      fit: BoxFit.contain),
                                  // child: Card(
                                  //     child: ClipRRect(
                                  //   borderRadius: BorderRadius.circular(4),
                                  //   child: Image.network(
                                  //     document.get('imageUrl'),
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          Flexible(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 1.0,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Text(
                                    document.get('servicename'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 10,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                        ],
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
