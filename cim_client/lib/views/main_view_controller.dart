import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart' hide Trans;

enum MainMenuItems {
  item_patients,
  item_schedule,
  item_protocol,
  item_messages
}

class MainViewController extends GetxController {
  CIMDataProvider dataProvider;
  Rx<MainMenuItems> selectedItem;

  RxBool authorised;

  bool isAuthorised() => authorised.value;

  void authorise(CIMUser user) {
    //TODO: Implement authorisation procedure
    authorised.value = true;
  }

  void onSelectMainMenuItem(MainMenuItems item) {
    if (item == selectedItem.value) return;
    selectedItem.value = item;
  }

  @override
  void onInit() {
    super.onInit();
    dataProvider = CIMDataProvider();
    selectedItem = Rx(MainMenuItems.item_patients);
    authorised = false.obs;
  }
}
