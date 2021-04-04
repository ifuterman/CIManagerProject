import 'package:cim_client2/apps/home/src/home_view.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/services/global_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

class HomeViewController extends AppGetxController with SmartNavigationMixin<HomeViewController>{

  final title$ = ''.obs;

  @override
  get defaultGetPageBuilder => () => HomeView();

  @override
  void onInit() {
    super.onInit();
    final gs = Get.find<GlobalService>();
    subscriptions.add(gs.title$.listen((v){
      title$(v);
    }));
    title$(gs.title$());
  }

}
