import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

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
