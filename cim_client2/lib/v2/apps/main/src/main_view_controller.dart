import 'package:cim_client2/v2/shared/app_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'patients/patients_view_controller.dart';
import 'profile/profile_view_controller.dart';
import 'protocol/protocol_view_controller.dart';
import 'shedule/shedule_view_controller.dart';

enum MenuItem {
  patients,
  schedule,
  protocol,
  profile,
  messages,
}


class MainViewController extends GetxControllerProxy
    with SmartNavigationMixin<MainViewController>

{
  MainViewController(){
    subWidgetPlacer$.value = Container();
  }

  final selectedItem$ = MenuItem.patients.obs;

  SmartNavigationMixin? _lastSmartNavigation;


  Future openSub(MenuItem item, {args}) async {
    selectedItem$(item);
    debugPrint('$now: MainViewController.openSub');
    _processPagingHide();
    _lastSmartNavigation?.close();
    _lastSmartNavigation = null;

    selectedItem$(item);
    switch (item) {
      case MenuItem.patients:
        _lastSmartNavigation =
            await _put<PatientsViewController>(() => PatientsViewController());
        break;
      case MenuItem.schedule:
        _lastSmartNavigation =
        await _put<SheduleViewController>(() => SheduleViewController());
        break;
      case MenuItem.protocol:
        _lastSmartNavigation =
        await _put<ProtocolViewController>(() => ProtocolViewController());
        break;
      case MenuItem.profile:
        _lastSmartNavigation =
        await _put(() => ProfileViewController());
        break;
      case MenuItem.messages:
        break;
    }
    _processPagingShow();
  }

  /// Управление вызовом колбека открытия страницы
  void _processPagingShow(){
    if(_lastSmartNavigation != null && _lastSmartNavigation is AppPageController){
      final c = _lastSmartNavigation as AppPageController;
      c.onPageShow(c);
    }
  }

  /// Управление вызовом колбека закрытия страницы
  void _processPagingHide(){
    if(_lastSmartNavigation != null && _lastSmartNavigation is AppPageController){
      final c = _lastSmartNavigation as AppPageController;
      c.onPageHide(c);
    }
  }

  Future<T> _put<T extends SmartNavigationMixin>(T Function() factory, {args}) async {
    return SmartNavigation.put<T>(
      factory()
        ..subWidgetNavigate(
          subWidgetPlacer$: subWidgetPlacer$,
          onClose: _subClose,
          args: args,
        ),
    );
  }

  void _subClose<T>(T c, {dynamic args}) {
    debugPrint('$now: MainViewController._subClose');
    _lastSmartNavigation = null;
    subWidgetPlacer$(Container());
  }


  @override
  void onInit() {
    super.onInit();
    debugPrint('$now: MainViewController.onInit');
  }

  @override
  void onReady() {
    super.onReady();
    openSub(MenuItem.schedule);
  }

}
