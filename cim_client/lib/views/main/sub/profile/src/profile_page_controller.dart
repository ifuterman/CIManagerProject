import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/views/main/sub/new_user/new_user.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'profile_page.dart';

class ProfilePageController extends GetxController
    with SmartNavigationMixin<ProfilePageController> {

  final user$ = Rx<CIMUser>(CIMUser('a', 'b'));
  final users$ = RxList<CIMPatient>();

  ProfilePageController(){
    subWidgetPlacer$(defaultSubWidgetBuilder());
  }

  @override
  GetPageBuilder get defaultGetPageBuilder => () => ProfilePage();

  @override
  ProfileSubView Function() get defaultSubWidgetBuilder => () => ProfileSubView();

  void makeUser() {
    debugPrint('$now: ProfilePageController.makeUser');
    Get.put(NewUserViewController()..subWidgetNavigate(
        subWidgetPlacer$: subWidgetPlacer$,
        onClose: (c, {args}){
          subWidgetPlacer$(defaultSubWidgetBuilder());
          delayMilli(1).then((_) {
            fetch();
          });
        }));
  }

  void fetch() {
    print('ProfilePageController.fetch');
    final dp = Get.find<DataProvider>();
    delayMilli(1000).then((_) {
      dp.getUsers().then((value) {
        debugPrint('$now: ProfilePageController.fetch.value: ${value}');
        if (value.result == CIMErrors.ok) {
          debugPrint('$now: ProfilePageController.fetch.result: ${value.data}');
          users$(value.data);
        } else {
          Get.snackbar(null, 'create first: ${value.result}');
        }
      });
    });

  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('$now: ProfilePageController.onReady');
    final dp = Get.find<DataProvider>();
    dp.getUserInfo().then((value) {
      debugPrint('$now: ProfilePageController.onReady.2: getUserInfo().then($value)');
      if(value.result == CIMErrors.ok){
        final user = value.data;
        debugPrint('$now: ProfilePageController.onReady: $user');
        user$(user);
      }
    });

    fetch();

  }

}
