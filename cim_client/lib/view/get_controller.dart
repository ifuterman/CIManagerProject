import 'package:cim_client/CIMDataProvider.dart';
import 'package:cim_client/CIMUser.dart';
import 'package:cim_client/view/get_view_model.dart';
import 'package:get/get.dart';

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
  CIMDataProvider dataProvider = CIMDataProvider();
  Rx<MainMenuItems> selectedItem = Rx(MainMenuItems.item_patients);
  Rx<CIMViews> currentView = Rx(CIMViews.authorisation_view);
  AuthorisationViewModel authViewModel = AuthorisationViewModel();
  ConnectionViewModel connectionViewModel = ConnectionViewModel();
  PatientsScreenModel patientsScreenModel = PatientsScreenModel();
  RxBool authorised = false.obs;
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
    if(item == selectedItem)
      return;
    selectedItem.value = item;
  }
}