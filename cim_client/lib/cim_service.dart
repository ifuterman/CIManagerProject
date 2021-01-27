import 'package:get/get.dart' hide Trans;
//import 'package:easy_localization/easy_localization.dart';
import 'cim_connection.dart';
import 'cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';

enum CIMViews{
  authorisationView,
  connectionView,
  mainView
}

class CIMService extends GetxService{
  CIMConnection connection;
  CIMUser user;
  Rx<CIMViews> currentView;

  @override
  void onInit() {
    super.onInit();
    connection = Get.put(CIMConnection("127.0.0.1", 8888));
    currentView = Rx(CIMViews.authorisationView);
    user = CIMUser("", "");
  }

  CIMDataProvider dataProvider;
}