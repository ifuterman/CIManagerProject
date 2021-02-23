import 'package:cim_client/data/cache_api_provider.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/pref_service.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/auth/authorisation_view_controller.dart';
import 'package:cim_client/views/connect/connection_view_controller.dart';
import 'package:cim_client/views/main/main_view.dart';
import 'package:cim_client/views/main/main_view_controller.dart';
import 'package:cim_client/views/shared/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class GlobalViewService extends GetxService {
  static const initialRoute = AppRoutes.splash;

  ICacheProvider provider;

  final connectionState$ = Rx<ConnectionStates>(ConnectionStates.unknown);

  Future init() async => this;

  @override
  void onInit() {
    super.onInit();
    provider = Get.put(CacheProvider());
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
          connectionState$(ConnectionStates.connected);
          _toAuthForm();
        } else {
          connectionState$(ConnectionStates.disconnected);
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
    final pref = Get.find<PreferenceService>();
    final user = pref.getUser();
    if(user == null){
      Get.put<AuthorisationViewController>(AuthorisationViewController()
        ..pageNavigate(
            onClose: (c, {args}){
              //_startChooseLang();
              debugPrint('$now: GlobalViewService._toAuthForm.CLOSE');
            },
            args: 'from $runtimeType._toAuthForm')
      );
    }else{
      Get.put<MainViewController>(MainViewController()
        ..pageNavigate(
            onClose: (c, {args}){
            },
            args: 'from $runtimeType._toAuthForm')
      );
    }
  }

  void _toConnectForm() {
    Get.put<ConnectionViewController>(ConnectionViewController()
      ..pageNavigate(
          onClose: (c, {args}){
            //_startChooseLang();
            debugPrint('$now: GlobalViewService._toConnectForm.CLOSE');
          },
          args: 'from $runtimeType._toConnectForm')
    );
  }

}
