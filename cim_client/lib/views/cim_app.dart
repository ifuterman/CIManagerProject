import 'package:cim_client/cim_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'authorisation_view.dart';
import 'connection_view.dart';
import 'main_view.dart';

class CIMApp extends StatelessWidget {
  final service = Get.put(CIMService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => getView(service.currentView.value)),
    );
  }

  Widget getView(CIMViews view) {
    switch (view) {
      case CIMViews.authorisationView:
        {
          return AuthorisationView();
        }
      case CIMViews.mainView:
        {
          return MainView();
        }
      case CIMViews.connectionView:
        {
          return ConnectionView();
        }
      default:
        return Container();
    }
  }
}
