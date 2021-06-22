import 'package:cim_client2/v2/shared/app_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'protocol_view.dart';

class ProtocolViewController extends AppPageController
    with SmartNavigationMixin<ProtocolViewController> {
  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => ProtocolView();

  @override
  void onClose() {
    debugPrint('$now: ScheduleViewController.onClose');
    super.onClose();
  }
}
