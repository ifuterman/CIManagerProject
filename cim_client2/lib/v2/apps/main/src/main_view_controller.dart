import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';

enum MenuItem {
  patients,
  schedule,
  protocol,
  messages,
  profile
}


class MainViewController extends GetxControllerProxy{

  final selectedItem$ = MenuItem.patients.obs;
  final panelPlacer$ = Rx<Widget>(Container());

  void openSub(MenuItem item, {args}) {
    // _lastSmartNavigation?.close();
    // _lastSmartNavigation = null;
    //
    // selectedItem$(item);
    // switch (item) {
    //   case MainMenuItems.item_patients:
    //     _lastSmartNavigation =
    //         _put<PatientsScreenController>(() => PatientsScreenController());
    //     break;
    //   case MainMenuItems.item_schedule:
    //     _lastSmartNavigation = _put<SecondController>(() => SecondController());
    //     break;
    //   case MainMenuItems.item_protocol:
    //   case MainMenuItems.item_messages:
    //     _lastSmartNavigation = _put<ThirdController>(() => ThirdController());
    //     break;
    //   case MainMenuItems.itemProfile:
    //     _lastSmartNavigation =
    //         _put<ProfilePageController>(() => ProfilePageController(), args: args);
    //     break;
    // }
  }


  @override
  void onInit() {
    super.onInit();
    debugPrint('$now: MainViewController.onInit');
  }

}
