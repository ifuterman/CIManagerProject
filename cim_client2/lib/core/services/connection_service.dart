import 'package:cim_client2/apps/home/src/home_view_controller.dart';
import 'package:cim_client2/apps/splash/splash.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/routes.dart';
import 'package:cim_client2/data/cim_errors.dart';
import 'package:cim_client2/data/provider/data_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:window_size/window_size.dart';

class ConnectionService extends AppGetxService {

  final connector$ = Rx<Boolean<CIMErrors>>(True(data: CIMErrors.initial));

  late DataProvider _provider;
  
  
  @override
  void onInit() {
    super.onInit();
    _provider = Get.find<DataProvider>();
  }
  
  void connect() {
    delayMilli(2000).then((_) {
      debugPrint('$now: ConnectionService.connect');
      _provider.checkConnection().then((value) {
        connector$(value);
      });
    });
  }

}
