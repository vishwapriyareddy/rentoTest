import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roi_test/colors.dart';

class MapLoaction extends StatefulWidget {
  static const String id = 'map';

  const MapLoaction({Key? key}) : super(key: key);

  @override
  _MapLoactionState createState() => _MapLoactionState();
}

class _MapLoactionState extends State<MapLoaction> {
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(
          13.048088,
          80.1714304,
        ),
        infoWindow: InfoWindow(
            title: "Rent O Integrated ",
            snippet: "The firm engages in providing best services ."),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Locate Us",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          padding: EdgeInsets.only(bottom: 50),
          initialCameraPosition:
              CameraPosition(target: LatLng(13.03886, 80.172707), zoom: 15),
        ),
      ),
    );
  }
}
