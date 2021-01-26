import 'package:cim_client/cim_service.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_client/cim_connection.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:cim_client/globals.dart';
import 'package:flutter/material.dart';

class AuthorisationViewController extends GetxController{
  CIMUser user = CIMUser("", "");
  void authoriseUser()
  {
    CIMConnection connection = Get.find();
    var res = connection.authoriseUser(user);
    res.then((value) {
      if(value == 0){
        CIMService service = Get.find();
        service.currentView.value =  CIMViews.main_view;
        return;
      }
      String message = mapError[value].tr();
      Get.defaultDialog(
        title: "error".tr(),
        middleText: message,
        confirm: RaisedButton(
          child: Text("OK".tr()),
          onPressed: ()=>Get.back(),
        ),
      );
      return;
    });
  }
}