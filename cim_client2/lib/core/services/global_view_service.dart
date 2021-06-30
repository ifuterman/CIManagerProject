import 'package:cim_client2/routing/routing.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:window_size/window_size.dart';

import 'data_service.dart';

class GlobalViewService extends GetxServiceProxy{
  static const initialRoute = RouteNames.splash;

  final title$ = ''.obs;

  @override
  void onReady() {
    super.onReady();
    delayMilli(1000).then((_) {
      title$('title'.tr());
      if(!GetPlatform.isWeb && !GetPlatform.isMobile){
        // this way (with delaying) one can change title on Desktops
        setWindowTitle('title'.tr());
      }
    });
    delayMilli(1000).then((_) {
      debugPrint('$now: GlobalViewService.onReady');
      // _toMain();
      _toConnect();
    });
  }

  void _toMain() {
    Get.offAllNamed(RouteNames.main);
  }

  void _toConnect() {
    Get.offAllNamed(RouteNames.connect);
  }

}