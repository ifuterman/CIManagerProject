import 'package:cim_client/cim_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:cim_client/cim_connection.dart';
import 'package:cim_client/globals.dart';

enum ConnectionStates{
  checking,
  connected,
  disconnected,
  unknown
}

class ConnectionViewController extends GetxController{
  CIMConnection connection;
  CIMService service = Get.find();
  String address;
  int port;
  RxBool updateScreenTrigger = RxBool(false);
  void updateScreen() => updateScreenTrigger.value = !updateScreenTrigger.value;
  ConnectionStates _connectionState = ConnectionStates.unknown;

  ConnectionStates get connectionState => _connectionState;

  set connectionState(ConnectionStates value) {
    _connectionState = value;
    updateScreen();
  }

  void applyConnection() {
    Get.delete<CIMConnection>();
    Get.put(connection);
    service.currentView.value = CIMViews.authorisation_view;
  }

  void cancelConnection(){
    connection.dispose();
    service.currentView.value = CIMViews.authorisation_view;
  }

  void init(){
    connection = Get.find();
    address = connection.address;
    port = connection.port;
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
  void onCheckConnection(){
    connection = CIMConnection(address, port);
    connection.init();

    connectionState = ConnectionStates.checking;
    connection.checkConnection().then((value){
      if(value == CIMErrors.ok){
        connectionState = ConnectionStates.connected;
      }
      else{
        connectionState = ConnectionStates.disconnected;
        String message = mapError[value].tr();
        Get.defaultDialog(
          title: "error".tr(),
          middleText: message,
          confirm: RaisedButton(
            child: Text("OK".tr()),
            onPressed: ()=>Get.back(),
          ),
        );
      }
    });
  }
}