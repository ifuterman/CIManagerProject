import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/views/global_view_service.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'new_user_view.dart';

class NewUserViewController extends GetxController
    with SmartNavigationMixin<NewUserViewController> {

  var name = '';
  var password = '';

  @override
  NewUserView Function() get defaultSubWidgetBuilder => () => NewUserView();

  void cancel() {
    close();
  }

  void changeName(String name) {
    this.name = name;
  }

  void changePassword(String password) {
    this.password = password;
  }

  void processing() {

    final candidate = CIMPatient(100, name, password, Sex.female);
    DataProvider _dataProvider;
    _dataProvider = Get.find<DataProvider>();
    _dataProvider.createPatient(candidate).then((value) async {
      if (value.result == CIMErrors.ok) {
        debugPrint('$now: NewUserViewController.processing: OK');
        _dataProvider.getUsers().then((value) {
          return null;
        });


      } else {
        Get.snackbar(null, 'create first: ${value.result}');
      }
    });


    ScaffoldMessenger.of(Get.context).showSnackBar(
      SnackBar(
        content: Text('Processing Data'),
        duration: Duration(seconds: 1),
      ),
    );
    close();
  }

// @override
// Future<bool> close({bool result = true, args}) {
//   return super.close(args: NavArgs.simple('USER'));
// }

}
