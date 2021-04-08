import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:vfx_flutter_common/utils.dart';

/// Общее поведение для сервиса
/// [subscriptions] позволяет управлять временем жизни подписок
abstract class AppGetxService extends GetxService{
  final subscriptions = rx.CompositeSubscription();

  @mustCallSuper
  @override
  void onClose() {
    subscriptions.clear();
    super.onClose();
  }
}

/// Общее поведение для контроллера
/// [subscriptions] позволяет управлять временем жизни подписок
abstract class AppGetxController extends GetxController{
  final subscriptions = rx.CompositeSubscription();

  @mustCallSuper
  @override
  void onClose() {
    subscriptions.clear();
    super.onClose();
  }
}

/// Тупо сокращатель [controller] -> [c]
abstract class AppGetView<T> extends GetView<T> {
  const AppGetView({Key? key}) : super(key: key);
  T get c => super.controller;
}

/// Handy mixin for nsvigating between pages, expecially in [PageView]///
mixin PageNavigatorMixin {
  void showPage({dynamic args}) {}
  void hidePage({dynamic args}) {}
}

/// For navigation
abstract class NavArgs {

  static const defaultKey = 'default';
  static const startNavKey = 'start_navigation';
  //
  static const toNewUser = 'new_user';
  static const toLoginSettings = 'login_settings';

  static safeValue<T>(Map<String, dynamic>? args, {String? key, defValue}){
    if(args == null){
      return null;
    }

    key ??= defaultKey;
    if(args.containsKey(key)){
      return args[key] as T;
    }
    return defValue;
  }

  static Map<String, dynamic> simple(value) => {defaultKey: value};
}

abstract class AppSnackbar{
  static void std(String message, {String? title}){
    title ??= '';
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 0,
      barBlur: 0,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: EdgeInsets.all(0),
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    );
  }

  /// With red color
  static void alarm(String message, {String? title}){
    title ??= '';
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      borderRadius: 0,
      barBlur: 0,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: EdgeInsets.all(0),
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    );
  }
}

