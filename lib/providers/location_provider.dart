import 'package:geocoder/geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  bool loading = false;
  var selectedAddress;

  // Future<Position> getCurrentPosition() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   print(position);
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);

  //   if (position != null) {
  //     this.latitude = position.latitude;
  //     this.longitude = position.longitude;
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(position.latitude, position.longitude);
  //     Placemark newPlacemark = placemarks.first;
  //     selectedAddress = newPlacemark.locality! +
  //         '\n' +
  //         newPlacemark.street! +
  //         '\t' +
  //         newPlacemark.subLocality! +
  //         '\t' +
  //         newPlacemark.thoroughfare! +
  //         '\t' +
  //         newPlacemark.name! +
  //         '\t' +
  //         newPlacemark.postalCode!;
  //     this.permissionAllowed = true;
  //     notifyListeners();
  //   } else {
  //     print('Permission not allowed');
  //   }
  //   return position;
  // }

  // void onCameraMove(CameraPosition cameraPosition) async {
  //   this.latitude = cameraPosition.target.latitude;
  //   this.longitude = cameraPosition.target.longitude;
  //   notifyListeners();
  // }

  // Future<void> getMoveCamera() async {
  //   Position position = await GeolocatorPlatform.instance
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark newPlacemark = placemarks.first;
  //   selectedAddress = newPlacemark.name!.toString() +
  //       '\n' +
  //       newPlacemark.subLocality!.toString() +
  //       '\t' +
  //       // newPlacemark.subThoroughfare!.toString() +
  //       // '\t' +
  //       newPlacemark.locality!.toString() +
  //       '\t' +
  //       newPlacemark.administrativeArea!.toString() +
  //       '\t' +
  //       newPlacemark.postalCode!.toString() +
  //       '\t' +
  //       newPlacemark.country!.toString();
  //   notifyListeners();

  //   print("${selectedAddress}");
  // }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', latitude!);
    prefs.setDouble('longitude', longitude!);
    prefs.setString('address', selectedAddress.addressLine!);
    prefs.setString('location', selectedAddress.featureName!);
  }

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      final coordinates = new Coordinates(this.latitude, this.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectedAddress = addresses.first;
      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print('Permission not allowed');
    }
      return position;
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    print("${selectedAddress.featureName}:${selectedAddress.addressLine}");
  }
}
