import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/auth/authorisation_view_controller.dart';
import 'package:cim_client/views/main/main_view_controller.dart';
import 'package:cim_client/views/shared/routes.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;

class GlobalViewService extends GetxService {
  static const initialRoute = AppRoutes.splash;

  final isDark$ = false.obs;

  Future init() async => this;

  @override
  void onReady() {
    super.onReady();
    debugPrint('$now: GlobalViewService.onReady');
    _start();
  }

  Future _start() async {
    debugPrint('$now: GlobalViewService._start');
    delayMilli(2000).then((_) {
      Get.put<AuthorisationViewController>(AuthorisationViewController()
        ..pageNavigate(
            onClose: (c, {args}){
              //_startChooseLang();
              debugPrint('$now: GlobalViewService._start');
            },
            args: 'from $runtimeType._start')
      );
    });
  }

}
