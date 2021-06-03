import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/views/auth/authorization_view_controller.dart';
import 'package:cim_client/views/connect/connection_view_controller.dart';
import 'package:cim_client/views/main/main_view_controller.dart';
import 'package:cim_client/views/shared/routes.dart';
import 'package:cim_client/views/temp_start/src/temp_start_view_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/utils.dart';

abstract class NavArgs {
  static const defaultKey = '_default_nav_arg_';
  static const startNavKey = 'start_navigation';
  static const toNewUser = 'new_user';

  static safeValue(Map<String, dynamic>? args, {String? key, defValue}) {
    key ??= defaultKey;
    if (!(args?.containsKey(key) ?? false)) {
      return defValue;
    }
    return args![key];
  }

  static Map<String, dynamic> simple(value) => {defaultKey: value};
}

class GlobalViewService extends GetxService {
  static const initialRoute = AppRoutes.splash;

  static const initialArgs = <String, dynamic>{
    NavArgs.startNavKey: NavArgs.toNewUser,
  };

  DataProvider? provider;

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
    delayMilli(2000).then((_) {
      // _startTemp();
      _start();
    });
  }

  void _startTemp() {
    Get.put<TempStartViewController>(TempStartViewController()
      ..toPage(
          // onClose: (c, {args}) {
          //
          // }
          ));
  }

  Future _start() async {
    provider!.checkConnection().then((value) {
      debugPrint('$now: GlobalViewService._start: $value');
      if (value == CIMErrors.ok) {
        Get.find<CacheProviderService>()
            .storage!
            .write('connect', ConnectionStates.connected.index);
        // connectionState$(ConnectionStates.connected);
        _toAuthForm();
      } else {
        Get.find<CacheProviderService>()
            .storage!
            .write('connect', ConnectionStates.disconnected.index);
        // connectionState$(ConnectionStates.disconnected);
        String message = mapError[value]!.tr();
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
  }

  void _toAuthForm() {
    final cache = Get.find<CacheProviderService>();
    final token = cache.fetchToken();
    print('$now: GlobalViewService._toAuthForm: token = $token');
    if (token == null) {
      Get.put<AuthorizationViewController>(
        AuthorizationViewController()
          ..toPage(
              onClose: (c, {args}) {
                debugPrint('$now: GlobalViewService._toAuthForm.CLOSE'
                    'NavArgs.safeValue($args)'
                    '');
                Get.back();
                if (NavArgs.safeValue(args) == true) {
                  _toMainForm();
                }
                if (NavArgs.safeValue(args) == 'reconnect') {
                  _toConnectForm();
                }
              },
              args: {NavArgs.defaultKey: 'from $runtimeType._toAuthForm'}),
      );
    } else {
      print('GlobalViewService._toAuthForm.2');
      _toMainForm();
    }
  }

  void _toMainForm() {
    print('GlobalViewService._toMainForm');
    final cache = Get.find<CacheProviderService>();
    Get.put<MainViewController>(MainViewController()
      ..toPage(
          onClose: (c, {args}) {
            Get.back();
            print('GlobalViewService._toMainForm.1: args = $args');
            print(
                'GlobalViewService._toMainForm.2: args = ${NavArgs.safeValue(args)}');
            if (NavArgs.safeValue(args) == 'clear_user') {
              cache.saveToken(null).then((value) {
                _toAuthForm();
              });
            }
          },
          args: initialArgs));
  }

  void _toConnectForm() {
    Get.put<ConnectionViewController>(ConnectionViewController()
      ..toPage(
          onClose: (c, {args}) {
            Get.back();
            if (args == true) {
              _toAuthForm();
            } else {
              if (c.connectionState$.value != ConnectionStates.connected) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else {
                _toAuthForm();
              }
            }
          },
          args: {NavArgs.defaultKey: 'from $runtimeType._toConnectForm'}));
  }
}
