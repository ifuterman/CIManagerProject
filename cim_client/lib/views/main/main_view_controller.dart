import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/main/main_view.dart';
import 'package:cim_client/views/main/patients_screen_controller.dart';
import 'package:cim_client/views/shared/smart_nav.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

enum MainMenuItems {
  item_patients,
  item_schedule,
  item_protocol,
  item_messages
}

class MainViewController extends GetxController
    with SmartNavigationMixin<MainViewController> {
  MainViewController() {
    subWidgetPlacer$.value = Container();
    print('$now: MainViewController.MainViewController');
  }

  CIMDataProvider dataProvider;

  Rx<MainMenuItems> selectedItem;

  RxBool authorised;

  bool isAuthorised() => authorised.value;

  @override
  GetPageBuilder get defaultGetPageBuilder => () {
    debugPrint('$now: MainViewController.defaultGetPageBuilder');
    return MainView();
  };

  SmartNavigationMixin _lastSmartNavigation;

  // FIXME(vvk): [MainMenuItems] -> MainMenuItem
  void openSub(MainMenuItems item) {
    _lastSmartNavigation?.close();
    _lastSmartNavigation = null;

    selectedItem(item);
    switch (item) {
      case MainMenuItems.item_patients:
        print('$now: MainViewController.openSub');
        _lastSmartNavigation = Get.put<PatientsScreenController>(
            PatientsScreenController()
              ..subWidgetNavigate(
                  subWidgetPlacer$: subWidgetPlacer$, onClose: _subClose));
        break;
      case MainMenuItems.item_schedule:
        _lastSmartNavigation = Get.put<SecondController>(SecondController()
          ..subWidgetNavigate(
              subWidgetPlacer$: subWidgetPlacer$, onClose: _subClose));
        break;
      case MainMenuItems.item_protocol:
      case MainMenuItems.item_messages:
        _lastSmartNavigation = Get.put<ThirdController>(ThirdController()
          ..subWidgetNavigate(
              subWidgetPlacer$: subWidgetPlacer$, onClose: _subClose));
        break;
    }
  }

  void _subClose(SmartNavigationMixin smart, {args}) {
    print('$now: MainViewController._subClose: $smart');
    // smart.destroy();
    // smart?.destroy<T>();
  }

  void beforeClose() {
    subWidgetPlacer$.value = Container();
    print('$now: MainViewController.beforeClose');
  }

  void authorise(CIMUser user) {
    //TODO: Implement authorisation procedure
    authorised.value = true;
  }

  void onSelectMainMenuItem(MainMenuItems item) {
    if (item == selectedItem.value) return;
    selectedItem.value = item;
  }

  void clearUser() {
    close(args: 'clear_user');
  }

  @override
  void onInit() {
    super.onInit();
    dataProvider = CIMDataProvider();
    print('$now: MainViewController.onInit');
    selectedItem = Rx(MainMenuItems.item_patients);
    authorised = false.obs;
  }

  @override
  void onReady() {
    super.onReady();
    print('$now: MainViewController.onReady');
    openSub(MainMenuItems.item_patients);
  }

  @override
  void onClose() {
    print('$now: MainViewController.onClose');
    super.onClose();
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
