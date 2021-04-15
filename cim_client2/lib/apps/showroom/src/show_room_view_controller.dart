import 'package:cim_client2/core/getx_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

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

  @override
  void onInit() {
    super.onInit();
    _state = _MainState();
  }

}

abstract class State extends Equatable{
  State({required this.title, required this.icon});
  final String title;
  final Icon icon;

  static final main = _MainState();
  static final splash = _SplashState();
  static final home = _HomeState();

  @override
  List<Object> get props => [title];
}

class _MainState extends State {
  _MainState() : super(title: 'main', icon: Icon(Icons.home));
}

class _SplashState extends State {
  _SplashState() : super(title: 'main', icon: Icon(Icons.stream));
}

class _HomeState extends State {
  _HomeState() : super(title: 'main', icon: Icon(Icons.login));
}
