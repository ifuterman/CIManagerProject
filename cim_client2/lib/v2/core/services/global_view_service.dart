import 'package:cim_client2/v2/routing/routing.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/utils.dart';

class GlobalViewService extends GetxServiceProxy{
  static const initialRoute = RouteNames.splash;
  final title$ = ''.obs;


  @override
  void onReady() {
    super.onReady();
    delayMilli(2000).then((_) {
      debugPrint('$now: GlobalViewService.onReady');
      Get.offAllNamed(RouteNames.main);
    });
  }
}