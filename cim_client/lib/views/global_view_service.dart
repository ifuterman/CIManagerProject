import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/views/auth/authorization_view_controller.dart';
import 'package:cim_client/views/connect/connection_view_controller.dart';
import 'package:cim_client/views/main/main_view_controller.dart';
import 'package:cim_client/views/shared/routes.dart';
import 'package:cim_client/cim_errors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:vfx_flutter_common/utils.dart';

class GlobalViewService extends GetxService {
  static const initialRoute = AppRoutes.splash;

  DataProvider provider;

  // final connectionState$ = Rx<ConnectionStates>(ConnectionStates.unknown);

  Future init() async => this;

  @override
  void onInit() {
    super.onInit();
    provider = Get.put(DataProviderImpl());
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('$now: GlobalViewService.onReady');
    _start();
  }

  Future _start() async {
    debugPrint('$now: GlobalViewService._start');
    delayMilli(2000).then((_) {
      provider.checkConnection().then((value) {
        if (value == CIMErrors.ok) {
          GetStorage().write('connect', ConnectionStates.connected.index);
          // connectionState$(ConnectionStates.connected);
          _toAuthForm();
        } else {
          GetStorage().write('connect', ConnectionStates.disconnected.index);
          // connectionState$(ConnectionStates.disconnected);
          String message = mapError[value].tr();
          Get.defaultDialog(
            title: "error".tr(),
            middleText: message,
            confirm: RaisedButton(
              child: Text("close".tr()),
              onPressed: () {
                Get.back();
                _toConnectForm();
              },
            ),
          );
        }
        return null;
      });
    });
  }

  void _toAuthForm() {
    final cache = Get.find<CacheProvider>();
    final token = cache.fetchToken();
    print('$now: GlobalViewService._toAuthForm: token = $token');
    if (token == null) {
      Get.put<AuthorizationViewController>(AuthorizationViewController()
          ..toPage(
              onClose: (c, {args}) {
                debugPrint('$now: GlobalViewService._toAuthForm.CLOSE');
                Get.back();
                if (args == true) {
                  _toMainForm();
                }
                if(args == 'reconnect'){
                  _toConnectForm();
                }
              },
              args: 'from $runtimeType._toAuthForm'),
      );
    } else {
      _toMainForm();
    }
  }

  void _toMainForm() {
    debugPrint('$now: GlobalViewService._toMainForm');
    final cache = Get.find<CacheProvider>();
    Get.put<MainViewController>(MainViewController()
      ..toPage(
          onClose: (c, {args}) {
            debugPrint(
                '$now: GlobalViewService._toAuthForm: MainViewController.onClose');
            Get.back();
            if (args == 'clear_user') {
              cache.saveToken(null).then((value) {
                _toAuthForm();
              });
            }
          },
          args: 'from $runtimeType._toAuthForm'));
  }

  void _toConnectForm() {
    Get.put<ConnectionViewController>(ConnectionViewController()
      ..toPage(
          onClose: (c, {args}) {
            Get.back();
            if (args == true) {
              _toAuthForm();
            }else{
              // Get.back();
            }
          },
          args: 'from $runtimeType._toConnectForm'));
  }
}
