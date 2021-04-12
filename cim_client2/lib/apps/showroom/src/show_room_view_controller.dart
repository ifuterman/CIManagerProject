import 'package:cim_client2/apps/showroom/showroom.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'home_view.dart';
import 'splash_view.dart';


class ShowRoomViewController extends AppGetxController
    with SmartNavigationMixin<ShowRoomViewController> {

  @override
  get defaultGetPageBuilder => () => ShowRoomView();

  late _State _state;

  void mainState() {
    if(_state is! _MainState){
      Get.back();
    }
    _state = _MainState();
  }

  void splashState() {
    if(_state is _MainState){
      Get.to(() => SplashView());
    }else{
      Get.off(() => SplashView());
    }
    _state = _SplashState();
  }

  void homeState() {
    if(_state is _MainState){
      Get.to(() => HomeView());
    }else{
      Get.off(() => HomeView());
    }
    _state = _HomeState();
  }

  void back() {
    mainState();
  }

  @override
  void onInit() {
    super.onInit();
    _state = _MainState();
  }

}

abstract class _State extends Equatable{
  _State({required this.title, required this.icon});
  final String title;
  final Icon icon;

  @override
  List<Object> get props => [title];
}

class _MainState extends _State {
  _MainState() : super(title: 'main', icon: Icon(Icons.login));
}

class _SplashState extends _State {
  _SplashState() : super(title: 'main', icon: Icon(Icons.login));
}

class _HomeState extends _State {
  _HomeState() : super(title: 'main', icon: Icon(Icons.login));
}
