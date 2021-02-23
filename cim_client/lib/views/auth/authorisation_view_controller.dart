import 'package:cim_client/cim_connection.dart';
import 'package:cim_client/cim_service.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/auth/authorisation_view.dart';
import 'package:cim_client/views/shared/smart_nav.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

enum AuthorisationState {idle, start, ok, error}

class AuthorisationViewController extends GetxController with SmartNavigationMixin{
  final user = CIMUser("", "");

  final state$ = Rx<AuthorisationState>(AuthorisationState.idle);

  @override
  PageBuilder get defaultPageBuilder => () => off(() => AuthorisationView());

  void authoriseUser({String login, String password}) {
    state$(AuthorisationState.start);
    delayMilli(2000).then((_) {
      state$(AuthorisationState.ok);
    });
    print('$now: >> AuthorisationViewController.authoriseUser');

    // CIMConnection connection = Get.find();
    // var res = connection.authoriseUser(user);
    // res.then((value) {
    //   if (value == CIMErrors.ok) {
    //     CIMService service = Get.find();
    //     service.currentView.value = CIMViews.mainView;
    //     return;
    //   }
    //   String message = mapError[value].tr();
    //   Get.defaultDialog(
    //     title: "error".tr(),
    //     middleText: message,
    //     confirm: RaisedButton(
    //       child: Text("OK".tr()),
    //       onPressed: () => Get.back(),
    //     ),
    //   );
    //   return;
    // });
  }
}
