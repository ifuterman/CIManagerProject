import 'package:cim_client2/core/cim_errors.dart';
import 'package:cim_client2/data/cache_provider.dart';
import 'package:cim_client2/routing/routing.dart';
import 'package:cim_client2/shared/app_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:rxdart/rxdart.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:easy_localization/easy_localization.dart';

import '../connect.dart';

enum ConnectionStates { checking, connected, disconnected, unknown }

class ConnectViewController extends GetxControllerProxy{
  CIMConnection? connection;

  String? address;
  int? port;
  final updateScreenTrigger$ = false.obs;

  final _subs = CompositeSubscription();

  @override
  get defaultGetPageBuilder => () => ConnectView();

  void updateScreen() => updateScreenTrigger$.value = !updateScreenTrigger$.value;

  final connectionState$ = ConnectionStates.disconnected.obs;

  void applyConnection() {
    if (Get.arguments != null) {
      Get.back();
    } else {
      Get.offAllNamed(RouteNames.main);
    }
  }

  void workOffline() {
    Get.offAllNamed(RouteNames.main);
  }

  void quitConnection() {
    Get.dialog(
        Material(
          elevation: 8,
          shadowColor: Colors.black12,
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 24, horizontal: 48),
              color: Colors.green[500],
              child: Text('BYE!'),
            ),
          ),
        ),
        barrierDismissible: false,
        // barrierColor: Colors.red,
        name: 'BUUU');
    delayMilli(2000).then((_) {
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      Get.back();
    });
  }

  void init() {
    debugPrint('$now: ConnectViewController.init: ');
    connection = Get.find();
    address = connection?.address;
    port = connection?.port;
  }

  @override
  void onInit() {
    super.onInit();

    debugPrint('$now: ConnectViewController.onInit: ${Get.arguments}');
    _subs.add(connectionState$.listen((v) {
      Get.find<CacheProviderService>().storage!.write('connect', v.index);
      updateScreen();
    }));
    init();
  }

  @override
  void onReady() {
    super.onReady();
    final i =
        Get.find<CacheProviderService>().storage?.read('connect') as int? ??
            ConnectionStates.disconnected.index;
    debugPrint('$now: ConnectionViewController.onReady: i = $i');
    connectionState$(ConnectionStates.values.elementAt(i));
  }

  @override
  void onClose() {
    debugPrint('$now: ConnectionViewController.onClose');
    _subs.clear();
    super.onClose();
  }

  void onCheckConnection() {
    debugPrint('$now: ConnectionViewController.onCheckConnection');
    connection = CIMConnection(address: address, port: port);
    connection?.init();

    connectionState$(ConnectionStates.checking);

    connection!.checkConnection().then((value) {
      debugPrint('$now: ConnectionViewController.onCheckConnection');
      if (value == CIMErrors.ok) {
        connectionState$(ConnectionStates.connected);
      } else {
        connectionState$(ConnectionStates.disconnected);
        String message = mapError[value]!.tr();
        AppDialog.std(
          message,
          title: "error".tr(),
          confirm: ElevatedButton(
            child: Text("ok".tr()),
            onPressed: () => Get.back(),
          ),
        );
      }
    });
  }
}

const Map<CIMErrors, String> mapError = {
  CIMErrors.connectionErrorServerNotFound: "connection_error_server_not_found",
  CIMErrors.connectionErrorServerDbFault: "connection_error_server_db_fault",
  CIMErrors.unexpectedServerResponse: "unexpected_server_response",
  CIMErrors.wrongUserCredentials: "wrong_user_credentials"
};

final salt = 'cim_project_salt';
