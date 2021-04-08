import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

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
