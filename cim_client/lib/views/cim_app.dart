import 'package:cim_client/cim_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'main_view_controller.dart';
import 'connection_view.dart';
import 'authorisation_view.dart';
import 'main_view.dart';

class CIMApp extends StatelessWidget {
  final service = Get.put(CIMService());

  @override
  Widget build(BuildContext context) {
//    return Scaffold(body: AuthorisationView());
    return Scaffold(
//      body: Obx(() => c.authorised.value ? MainView() : AuthorisationView())
      body: Obx(() => getView(service.currentView.value)),
    );
  }

  Widget getView(CIMViews view) {
    switch (view) {
      case CIMViews.authorisation_view:
        {
          return AuthorisationView();
        }
      case CIMViews.main_view:
        {
          return MainView();
        }
      case CIMViews.connection_view:
        {
          return ConnectionView();
        }
      default:
        return Container();
    }
  }
}