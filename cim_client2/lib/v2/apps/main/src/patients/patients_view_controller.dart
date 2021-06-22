import 'package:cim_client2/v2/shared/app_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'patients_view.dart';

class PatientsViewController extends AppPageController
    with SmartNavigationMixin<PatientsViewController> {
  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => PatientsView();

  @override
  void onClose() {
    debugPrint('$now: PatientsViewController.onClose');
    super.onClose();
  }
}
