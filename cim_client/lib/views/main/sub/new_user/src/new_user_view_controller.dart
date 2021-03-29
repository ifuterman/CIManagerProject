import 'package:cim_client/views/global_view_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

import 'new_user_view.dart';

class NewUserViewController extends GetxController
    with SmartNavigationMixin<NewUserViewController> {
  @override
  NewUserView Function() get defaultSubWidgetBuilder => () => NewUserView();

  void cancel() {
    close();
  }

  void processing() {
    ScaffoldMessenger.of(Get.context).showSnackBar(
      SnackBar(
        content: Text('Processing Data'),
        duration: Duration(seconds: 1),
      ),
    );
    close();
  }

// @override
// Future<bool> close({bool result = true, args}) {
//   return super.close(args: NavArgs.simple('USER'));
// }

}
