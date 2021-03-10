import 'package:cim_client/cim_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/utils.dart';

import 'auth/authorization_view.dart';
import 'connect/connection_view.dart';
import 'main/main_view.dart';

class CIMApp extends StatelessWidget {
  final service = Get.find<CIMService>();

  @override
  Widget build(BuildContext context) {
    debugPrint('$now: CIMApp.build');
    return Scaffold(
      body: Obx(() => getView(service.currentView.value)),
    );
  }

  Widget getView(CIMViews view) {
    switch (view) {
      case CIMViews.authorisationView:
        return AuthorizationView();
      case CIMViews.mainView:
        return MainView();
      case CIMViews.connectionView:
        return ConnectionView();
      default:
        return Container();
    }
  }
}
