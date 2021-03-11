import 'package:cim_client/cim_connection.dart';
import 'package:cim_client/cim_service.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/views/connect/connection_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

enum ConnectionStates { checking, connected, disconnected, unknown }

class ConnectionViewController extends GetxController
    with SmartNavigationMixin<ConnectionViewController> {
  CIMConnection connection;
  // CIMService service = Get.find();
  String address;
  int port;
  final updateScreenTrigger = false.obs;

  final _subs = CompositeSubscription();

  @override
  GetPageBuilder get defaultGetPageBuilder => () => ConnectionView();


  void updateScreen() => updateScreenTrigger.value = !updateScreenTrigger.value;

  final connectionState$ = ConnectionStates.disconnected.obs;

  // ConnectionStates get connectionState => _connectionState;
  //
  // set connectionState(ConnectionStates value) {
  //   _connectionState = value;
  //   updateScreen();
  // }

  void applyConnection() {
    close(args: true);
    // Get.delete<CIMConnection>();
    // Get.put(connection);
    // service.currentView.value = CIMViews.authorisationView;
  }

  void cancelConnection() {
    close(args: false);
    // connection.dispose();
    // service.currentView.value = CIMViews.authorisationView;
  }

  void init() {
    connection = Get.find();
    address = connection.address;
    port = connection.port;
  }

  @override
  void onInit() {
    super.onInit();
    _subs.add(connectionState$.listen((v) {
      GetStorage().write('connect', v.index);
      updateScreen();
    }));
    init();
  }

  @override
  void onReady() {
    super.onReady();
    final i = GetStorage().read('connect') as int ?? ConnectionStates.disconnected.index;
    connectionState$(ConnectionStates.values.elementAt(i));
  }

  @override
  void onClose() {
    debugPrint('$now: ConnectionViewController.onClose');
    _subs.clear();
    super.onClose();
  }

  void onCheckConnection() {
    connection = CIMConnection(address, port);
    connection.init();

    connectionState$(ConnectionStates.checking);

    connection.checkConnection().then((value) {
      debugPrint('$now: ConnectionViewController.onCheckConnection');
      if (value == CIMErrors.ok) {
        connectionState$(ConnectionStates.connected);
      } else {
        connectionState$(ConnectionStates.disconnected);
        String message = mapError[value].tr();
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
