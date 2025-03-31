import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((results) {
      for (var result in results) {
        _updateConnectionStatus(result);
      }
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
