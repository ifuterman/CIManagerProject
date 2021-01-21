import 'package:cim_client/CIMDataProvider.dart';
import 'package:cim_client/CIMUser.dart';
import 'package:cim_client/view/cim_connection.dart';
import 'package:cim_client/view/get_view_model.dart';
import 'package:get/get.dart' hide Trans;
import 'package:cim_client/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';



enum CIMViews{
  authorisation_view,
  connection_view,
  main_view
}

enum MainMenuItems{
  item_patients,
  item_schedule,
  item_protocol,
  item_messages
}

class Controller extends GetxController{
//class Controller extends GetxService{
  CIMConnection connection;
  CIMDataProvider dataProvider;
  Rx<MainMenuItems> selectedItem;
  Rx<CIMViews> currentView;
  AuthorisationViewModel authViewModel;
  ConnectionViewModel connectionViewModel;
  PatientsScreenModel patientsScreenModel;
  RxBool authorised;
  bool isAuthorised() => authorised.value;
  void authorise(CIMUser user){
    //TODO: Implement authorisation procedure
    authorised.value = true;
  }
  void onConnectionChanged(bool connectionOk, String newServer){
    currentView.value = CIMViews.authorisation_view;
    //TODO: Implement connection
  }

  void onSelectMainMenuItem(MainMenuItems item){
    if(item == selectedItem.value)
      return;
    selectedItem.value = item;
  }

  void checkConnection(){
    connection.address = connectionViewModel.address;
    connection.port = connectionViewModel.port;
    connection.connect().then((value){
      if(value == 0){
        connectionViewModel.connected = true;
      }
      else{
        connectionViewModel.connected = false;
        String message = mapError[value].tr();
        Get.defaultDialog(
            title: "error".tr(),
            middleText: message,
            confirm: RaisedButton(
              child: Text("OK".tr()),
              onPressed: ()=>Get.back(),
            ),
        );
        connectionViewModel.updateScreen.value = true;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    dataProvider = CIMDataProvider();
    selectedItem = Rx(MainMenuItems.item_patients);
    currentView = Rx(CIMViews.authorisation_view);
    authViewModel = AuthorisationViewModel();
    connection = Get.put(CIMConnection());
    connectionViewModel = ConnectionViewModel();
    connectionViewModel.address = connection.address;
    connectionViewModel.port = connection.port;
    patientsScreenModel = PatientsScreenModel();
    authorised = false.obs;
  }
}