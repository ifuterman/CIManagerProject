import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_client/cim_connection.dart';
import 'package:cim_client/views/patients_screen_controller.dart';
import 'package:get/get.dart' hide Trans;
import 'package:cim_client/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


enum MainMenuItems{
  item_patients,
  item_schedule,
  item_protocol,
  item_messages
}

class MainViewController extends GetxController{
//class Controller extends GetxService{
//  CIMConnection connection;
  CIMDataProvider dataProvider;
  Rx<MainMenuItems> selectedItem;

//  AuthorisationViewModel authViewModel;
//  ConnectionViewModel connectionViewModel;
  RxBool authorised;
  bool isAuthorised() => authorised.value;
  void authorise(CIMUser user){
    //TODO: Implement authorisation procedure
    authorised.value = true;
  }
/*  void onConnectionChanged(){
    currentView.value = CIMViews.authorisation_view;
    //TODO: Implement connection
  }*/

  void onSelectMainMenuItem(MainMenuItems item){
    if(item == selectedItem.value)
      return;
    selectedItem.value = item;
  }



  @override
  void onInit() {
    super.onInit();
    dataProvider = CIMDataProvider();
    selectedItem = Rx(MainMenuItems.item_patients);
//    authViewModel = AuthorisationViewModel();
//    connection = Get.put(CIMConnection());
    authorised = false.obs;
  }
}