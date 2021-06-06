import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

abstract class NavArgs {
  static const defaultKey = '_default_nav_arg_';
  static const startNavKey = 'start_navigation';
  static const toNewUser = 'new_user';

  static safeValue(Map<String, dynamic>? args, {String? key, defValue}) {
    key ??= defaultKey;
    if (!(args?.containsKey(key) ?? false)) {
      return defValue;
    }
    return args![key];
  }

  static Map<String, dynamic> simple(value) => {defaultKey: value};
}


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

///
abstract class AppGetView<T> extends GetView<T> {
  const AppGetView({Key? key}) : super(key: key);
  T get c => super.controller;
}
