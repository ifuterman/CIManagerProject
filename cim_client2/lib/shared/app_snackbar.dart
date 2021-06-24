import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:vfx_flutter_common/utils.dart';

abstract class AppSnackbar{
  static void stdOrAlarm(bool isAlarm, String message, {String? title}){
    if(isAlarm){
      alarm(message, title: title);
    }else{
      std(message, title: title);
    }
  }

  static void std(String message, {String? title}){
    Get.rawSnackbar(
      title: title,
      message: message,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 0,
      barBlur: 0,
      backgroundColor: Colors.black,
      margin: EdgeInsets.all(0),
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    );
  }

  /// With red color
  static void alarm(String message, {String? title}){
    Get.rawSnackbar(
      title: title,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      borderRadius: 0,
      barBlur: 0,
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(0),
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    );
  }
}

