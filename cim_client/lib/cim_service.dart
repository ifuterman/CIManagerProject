import 'package:get/get.dart' hide Trans;
//import 'package:easy_localization/easy_localization.dart';
import 'views/cim_connection.dart';
import 'CIMDataProvider.dart';

enum CIMViews{
  authorisation_view,
  connection_view,
  main_view
}

class CIMService extends GetxService{
  CIMConnection connection;
  Rx<CIMViews> currentView;

  @override
  void onInit() {
    super.onInit();
    connection = Get.put(CIMConnection("127.0.0.1", 8888));
    currentView = Rx(CIMViews.authorisation_view);
  }

  CIMDataProvider dataProvider;
}