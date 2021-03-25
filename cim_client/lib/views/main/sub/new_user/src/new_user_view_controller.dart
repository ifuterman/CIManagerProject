import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'new_user_view.dart';

class NewUserViewController extends GetxController
    with SmartNavigationMixin<NewUserViewController> {

  @override
  NewUserView Function() get defaultSubWidgetBuilder => () => NewUserView();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<bool> close({bool result = true, args}) {
    return super.close(args: 'USER');
  }

}
