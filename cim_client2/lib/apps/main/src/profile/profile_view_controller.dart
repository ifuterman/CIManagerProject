import 'package:cim_client2/shared/app_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'profile_view.dart';

class ProfileViewController extends AppPageController
    with SmartNavigationMixin<ProfileViewController> {
  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => ProfileView();

  @override
  void onClose() {
    debugPrint('$now: ScheduleViewController.onClose');
    super.onClose();
  }
}
