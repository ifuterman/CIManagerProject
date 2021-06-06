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
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/utils.dart';

import 'shared/getx_helpers.dart';


class GlobalViewService extends AppGetxService {
  
  GlobalViewService({DataProvider? provider})
      : _provider = provider ?? Get.find<DataProvider>(); 
  
  static const initialRoute = AppRoutes.splash;

  static const initialArgs = <String, dynamic>{
    NavArgs.startNavKey: NavArgs.toNewUser,
  };

  final DataProvider _provider;

  // final connectionState$ = Rx<ConnectionStates>(ConnectionStates.unknown);

  Future init() async => this;

  @override
  void onInit() {
    super.onInit();
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
    _provider.checkConnection().then((value) {
      debugPrint('$now: GlobalViewService._start: $value');
      if (value == CIMErrors.ok) {
        _toMainForm();
        /*
        TODO(vvk): По уму тут надо на авторизацию,но пока перекидываю
          на [_toMainForm] для простоты. Оттуда есть переход на
          авторизацию
        * */
        // Get.find<CacheProviderService>()
        //     .storage!
        //     .write('connect', ConnectionStates.connected.index);
        // // connectionState$(ConnectionStates.connected);
        // _toAuthForm();
      } else {
        Get.find<CacheProviderService>()
            .storage!
            .write('connect', ConnectionStates.disconnected.index);
        // connectionState$(ConnectionStates.disconnected);
        String message = mapError[value]!.tr();
        Get.defaultDialog(
          barrierDismissible: false,
          title: "error".tr(),
          middleText: message,
          confirm: TextButton(
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
            _toMainForm();
            // if (args == true) {
            //   _toMainForm();
            //   // _toAuthForm();
            // } else {
            //   if (c.connectionState$.value != ConnectionStates.connected) {
            //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            //   } else {
            //     _toAuthForm();
            //   }
            // }
          },
          args: {NavArgs.defaultKey: 'from $runtimeType._toConnectForm'}));
  }
}
