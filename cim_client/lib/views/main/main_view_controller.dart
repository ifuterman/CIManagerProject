import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_client/views/global_view_service.dart';
import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:cim_client/views/main/main_view.dart';
import 'package:cim_client/views/main/sub/patient/src/patients_screen_controller.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import 'sub/profile/profile.dart';

enum MainMenuItems {
  item_patients,
  item_schedule,
  item_protocol,
  item_messages,
  itemProfile
}

class MainViewController extends AppGetxController
    with SmartNavigationMixin<MainViewController> {
  MainViewController() {
    subWidgetPlacer$.value = Container();
    print('$now: MainViewController.MainViewController');
  }

  CIMDataProvider dataProvider;

  final selectedItem$ = MainMenuItems.item_patients.obs;

  final authorised$ = false.obs;

  bool isAuthorised() => authorised$.value;

  @override
  GetPageBuilder get defaultGetPageBuilder => () => MainView();

  SmartNavigationMixin _lastSmartNavigation;

  @override
  Future afterNavigate({Map<String, dynamic> args}) async {
    final to = NavArgs.safeValue(args, key: NavArgs.startNavKey);
    if (to != null && to as String == NavArgs.toNewUser) {
      openSub(MainMenuItems.itemProfile, args: args);
    }
  }


  void openSub(MainMenuItems item, {args}) {
    _lastSmartNavigation?.close();
    _lastSmartNavigation = null;

    selectedItem$(item);
    switch (item) {
      case MainMenuItems.item_patients:
        _lastSmartNavigation =
            _put<PatientsScreenController>(() => PatientsScreenController());
        break;
      case MainMenuItems.item_schedule:
        _lastSmartNavigation = _put<SecondController>(() => SecondController());
        break;
      case MainMenuItems.item_protocol:
      case MainMenuItems.item_messages:
        _lastSmartNavigation = _put<ThirdController>(() => ThirdController());
        break;
      case MainMenuItems.itemProfile:
        _lastSmartNavigation =
            _put<ProfilePageController>(() => ProfilePageController(), args: args);
        break;
    }
  }

  // 2. Удобный метод для упрощения вызовов
  ///
  T _put<T extends SmartNavigationMixin>(T Function() factory, {args}) {
    return Get.put<T>(
      factory()
        ..subWidgetNavigate(
          subWidgetPlacer$: subWidgetPlacer$,
          onClose: _subClose,
          args: args,
        ),
    );
  }

  void _subClose<T>(T c, {dynamic args}) {
    _lastSmartNavigation = null;
    subWidgetPlacer$(Container());
  }

  void beforeClose() {
    subWidgetPlacer$.value = Container();
    print('$now: MainViewController.beforeClose');
  }

  void authorise(CIMUser user) {
    //TODO: Implement authorisation procedure
    authorised$.value = true;
  }

  void onSelectMainMenuItem(MainMenuItems item) {
    if (item == selectedItem$.value) return;
    selectedItem$.value = item;
  }

  void clearUser() {
    close(args: NavArgs.simple('clear_user'));
  }

  @override
  void onInit() {
    super.onInit();
    dataProvider = CIMDataProvider();
  }

}

class SecondController extends GetxController
    with SmartNavigationMixin<SecondController> {
  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => Container(
        child: Center(
          child: Text(
            runtimeType.toString(),
          ),
        ),
      );

  @override
  void onClose() {
    print('$now: SecondController.onClose');
    super.onClose();
  }
}

class ThirdController extends GetxController
    with SmartNavigationMixin<ThirdController> {
  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => Container(
        child: Center(
          child: Text(
            runtimeType.toString(),
          ),
        ),
      );

  @override
  void onClose() {
    print('$now: ThirdController.onClose');
    super.onClose();
  }

// @override
// Future<bool> close({bool result = true, args}) {
//   print('$now: ThirdController.close: ${typeOf<T>()}');
//   return super.close(result: result, args: args);
// }
}
