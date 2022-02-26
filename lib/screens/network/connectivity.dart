import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

enum ConnectivityStatus { Wifi, Mobile, Offline }

class ConnectivityService {
  StreamController<ConnectivityStatus> streamController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      streamController.add(_getstatus(connectivityResult));
    });
  }

  ConnectivityStatus _getstatus(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Mobile;

      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;

      default:
        return ConnectivityStatus.Offline;
    }
  }
}

class Appservice {
  Future<bool?> connection() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
      }
    } on SocketException catch (_) {
      internet = false;
    }
    return internet;
  }
}
