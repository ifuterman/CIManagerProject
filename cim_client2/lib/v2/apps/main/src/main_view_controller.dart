import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';


class MainViewController extends GetxControllerProxy{

  @override
  void onInit() {
    super.onInit();
    debugPrint('$now: MainViewController.onInit');
  }

}
