import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:vfx_flutter_common/utils.dart';

abstract class AppDialog{
  static void std(String message, {String? title,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Widget? confirm,
    Widget? cancel,
  }) {
    Get.defaultDialog(
      title: title ?? 'alert',
      middleText: message,
      radius: 0,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirm: confirm,
      cancel: cancel
    );
  }
}

