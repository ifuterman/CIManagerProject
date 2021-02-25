import 'package:cim_client/cim_connection.dart';
import 'package:cim_client/cim_service.dart';
import 'package:cim_client/data/cache_api_provider.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/auth/authorisation_view.dart';
import 'package:cim_client/views/main/main_view_controller.dart';
import 'package:cim_client/views/shared/smart_nav.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

enum AuthorisationState {idle, start, ok, error}

class AuthorisationViewController extends GetxController with SmartNavigationMixin{
  final user = CIMUser("", "");

  final state$ = AuthorisationState.idle.obs;

  final isValidData$ = false.obs;

  ICacheProvider provider;

  @override
  PageBuilder get defaultPageBuilder => () => off(() => AuthorisationView());

  void enterData({String login, String password}){
    isValidData$(
        (login?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false)
    );
  }

  void clearDb(){
    provider.cleanDb().then((value) {
      Get.snackbar('Clean DB', '$value');
    });
  }

  void authoriseUser({String login, String password}) {
    state$(AuthorisationState.start);
    // FIXME(vvk): в этом методе нет ничего от JSON
    // FIXME(vvk): [UserRoles] -> UserRole
    final candidate = CIMUser.fromJson(0, login, password, UserRoles.administrator);
    provider.createFirstUser(candidate).then((value) {
      state$(AuthorisationState.ok);
      if(value.result == CIMErrors.ok){
        Get.put<MainViewController>(MainViewController()
          ..pageNavigate(
              onClose: (c, {args}){
              },
              args: 'from $runtimeType._toAuthForm')
        );
      }else{
        Get.snackbar(null, '${value.result}');
      }
    });


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

  @override
  void onInit() {
    super.onInit();
    provider = Get.find<ICacheProvider>();
  }
}
