import 'package:cim_client2/shared/app_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'shedule_view.dart';

class SheduleViewController extends AppPageController
    with SmartNavigationMixin<SheduleViewController> {
  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => SheduleView();

  @override
  void onClose() {
    debugPrint('$now: ScheduleViewController.onClose');
    super.onClose();
  }
}
