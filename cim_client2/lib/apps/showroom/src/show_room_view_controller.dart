import 'package:cim_client2/core/getx_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

import 'excel_view_controller.dart';
import 'home_view_controller.dart';
import 'show_room_view.dart';
import 'splash_view_controller.dart';


class ShowRoomViewController extends AppGetxController
    with SmartNavigationMixin<ShowRoomViewController> {

  @override
  get defaultGetPageBuilder => () => ShowRoomView();

  late State _state;

  get state => _state;

  void mainState() {
    if(_state != State.main){
      Get.back();
    }
    _state = State.main;
  }

  void splashState() {
    if(_state == State.main){
      SmartNavigation.put(SplashViewController()..toPage(
        onClose: (c, {args}) {
          Get.back();
          _state = State.main;
        }
      ));
    }
    _state = State.splash;
  }

  void homeState() {
    if(_state == State.main){
      SmartNavigation.put(HomeViewController()..toPage(
          onClose: (c, {args}) {
            Get.back();
            _state = State.main;
          }
      ));
    }
    _state = State.home;
  }

  void excelState() {
    if(_state == State.main){
      SmartNavigation.put(ExcelViewController()..toPage(
          onClose: (c, {args}) {
            Get.back();
            _state = State.main;
          }
      ));
    }
    _state = State.home;
  }

  @override
  void onInit() {
    super.onInit();
    _state = _MainState();
  }

}

abstract class State extends Equatable{
  State({required this.key, required this.icon});
  /// Means key for get value from locale JSON
  final String key;
  final Icon icon;

  static final main = _MainState();
  static final splash = _SplashState();
  static final home = _HomeState();
  static final excel = _ExcelState();

  @override
  List<Object> get props => [key];
}

class _MainState extends State {
  _MainState() : super(key: 'main', icon: Icon(Icons.home));
}

class _SplashState extends State {
  _SplashState() : super(key: 'splash', icon: Icon(Icons.stream));
}

class _HomeState extends State {
  _HomeState() : super(key: 'home', icon: Icon(Icons.login));
}

class _ExcelState extends State {
  _ExcelState() : super(key: 'excel', icon: Icon(Icons.subscript));
}
