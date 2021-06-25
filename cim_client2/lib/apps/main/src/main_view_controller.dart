import 'package:cim_client2/core/utils.dart';
import 'package:cim_client2/routing/routing.dart';
import 'package:cim_client2/shared/app_page_controller.dart';
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
  cleanDb,
  messages,
}

class MainViewController extends GetxControllerProxy
    with SmartNavigationMixin<MainViewController> {
  final selectedItem$ = MenuItem.patients.obs;

  SmartNavigationMixin? _lastSmartNavigation;

  Future openSub(MenuItem item, {args}) async {
    selectedItem$(item);

    // вызывает метод отслеживания закрытия [AppPageController.onPageHide]
    // текущего суба
    _processPagingHide();
    _lastSmartNavigation?.close();
    _lastSmartNavigation = null;

    selectedItem$(item);
    switch (item) {
      case MenuItem.patients:
        _lastSmartNavigation = await _put<PatientsViewController>(
            () => PatientsViewController(),
            args: args);
        break;
      case MenuItem.schedule:
        _lastSmartNavigation = await _put<SheduleViewController>(
            () => SheduleViewController(),
            args: args);
        break;
      case MenuItem.protocol:
        _lastSmartNavigation = await _put<ProtocolViewController>(
            () => ProtocolViewController(),
            args: args);
        break;
      case MenuItem.profile:
        _lastSmartNavigation =
            await _put(() => ProfileViewController(), args: args);
        break;
      case MenuItem.cleanDb:
        _cleanDb();
        break;
      case MenuItem.messages:
        break;
    }

    // вызывает метод отслеживания открытия [AppPageController.onPageShow]
    // нового суба
    _processPagingShow();
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

  void _cleanDb() {
    Get.offAllNamed(RouteNames.auth);
  }

  /// Управление вызовом колбека открытия страницы
  void _processPagingShow() {
    if (_lastSmartNavigation != null &&
        _lastSmartNavigation is AppPageController) {
      final c = _lastSmartNavigation as AppPageController;
      c.onPageShow(c);
    }
  }

  /// Управление вызовом колбека закрытия страницы
  void _processPagingHide() {
    if (_lastSmartNavigation != null &&
        _lastSmartNavigation is AppPageController) {
      final c = _lastSmartNavigation as AppPageController;
      c.onPageHide(c);
    }
  }

  /// Хелпер для автоматический постройки субвью в рамках создания ее контроллера.
  /// [factory] - метод-фабрика создания контроллера.
  /// [args] набор аргументов, в которых предполагается (необязательное) наличие
  /// ключей для тегирования и управления временем жизни контроллеров
  Future<T> _put<T extends SmartNavigationMixin>(T Function() factory,
      {args}) async {
    /// Так строится контроллер субнавигации.
    /// Миксин [SmartNavigationMixin] содержит свойство [subWidgetPlacer$]
    /// которое следует передавать субам как точку размещения своих вьюх.
    return SmartNavigation.put<T>(
      factory()
        ..subWidgetNavigate(
          subWidgetPlacer$: subWidgetPlacer$,
          onClose: _subClose,
          args: args,
        ),
      tag: castToMapAndFind(args, MapKeys.controllerTag),
      permanent:
          castToMapAndFind(args, MapKeys.controllerPermanent, defValue: false)!,
    );
  }

  /// При закрытии суба следует замещать [subWidgetPlacer$]
  /// как минимум заглушкой.
  void _subClose<T>(T c, {dynamic args}) {
    debugPrint('$now: MainViewController._subClose');
    _lastSmartNavigation = null;
    subWidgetPlacer$(Container());
  }
}
