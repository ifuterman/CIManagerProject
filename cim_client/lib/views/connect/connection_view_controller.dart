import 'package:cim_client/cim_connection.dart';
import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/views/connect/connection_view.dart';
import 'package:cim_client/views/global_view_service.dart';
import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:rxdart/rxdart.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

enum ConnectionStates { checking, connected, disconnected, unknown }

class ConnectionViewController extends GetxController
    with SmartNavigationMixin<ConnectionViewController> {
  CIMConnection? connection;

  // CIMService service = Get.find();
  String? address;
  int? port;
  final updateScreenTrigger = false.obs;

  final _subs = CompositeSubscription();

  @override
  get defaultGetPageBuilder => () => ConnectionView();

  void updateScreen() => updateScreenTrigger.value = !updateScreenTrigger.value;

  final connectionState$ = ConnectionStates.disconnected.obs;

  // ConnectionStates get connectionState => _connectionState;
  //
  // set connectionState(ConnectionStates value) {
  //   _connectionState = value;
  //   updateScreen();
  // }

  void applyConnection() {
    close(args: NavArgs.simple(true));
    // Get.delete<CIMConnection>();
    // Get.put(connection);
    // service.currentView.value = CIMViews.authorisationView;
  }

  void cancelConnection() {
    // close(args: NavArgs.simple(false));
    onCheckConnection();
  }

  void init() {
    connection = Get.find();
    address = connection?.address;
    port = connection?.port;
  }

  @override
  void onInit() {
    super.onInit();
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
        Get.defaultDialog(
          title: "error".tr(),
          middleText: message,
          confirm: RaisedButton(
            child: Text("ok".tr()),
            onPressed: () => Get.back(),
          ),
        );
      }
    });
  }
}
