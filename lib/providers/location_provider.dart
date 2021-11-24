import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  bool loading = false;
  String? selectedAddress;
  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(position);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark newPlacemark = placemarks.first;
      selectedAddress = newPlacemark.locality! +
          '\n' +
          newPlacemark.street! +
          '\t' +
          newPlacemark.subLocality! +
          '\t' +
          newPlacemark.thoroughfare! +
          '\t' +
          newPlacemark.name! +
          '\t' +
          newPlacemark.postalCode!;
      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print('Permission not allowed');
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark newPlacemark = placemarks.first;
    selectedAddress = newPlacemark.locality! +
        '\n' +
        newPlacemark.street! +
        '\t' +
        newPlacemark.subLocality! +
        '\t' +
        newPlacemark.thoroughfare! +
        '\t' +
        newPlacemark.name! +
        '\t' +
        newPlacemark.postalCode!;
    notifyListeners();

    print("${selectedAddress}");
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', latitude!);
    prefs.setDouble('longitude', longitude!);
    prefs.setString('address', selectedAddress!);
  }
}
