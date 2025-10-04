import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result as ConnectivityResult);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
          messageText: Text(
            'No internet connection',
            style: TextStyle(color: Colors.white),
          ),
          isDismissible: false,
          duration: Duration(days: 1),
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.wifi_off,
            color: Colors.white,
          ),
          margin: EdgeInsets.zero,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
