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

  ProfilePageController(){
    subWidgetPlacer$(defaultSubWidgetBuilder());
  }

  @override
  GetPageBuilder get defaultGetPageBuilder => () => ProfilePage();

  @override
  ProfileSubView Function() get defaultSubWidgetBuilder => () => ProfileSubView();

  void makeUser() {
    Get.put(NewUserViewController()..subWidgetNavigate(
        subWidgetPlacer$: subWidgetPlacer$,
        onClose: (c, {args}){
          subWidgetPlacer$(defaultSubWidgetBuilder());
          delayMilli(1).then((_) {
            Get.snackbar('title', args.toString(), snackPosition: SnackPosition.BOTTOM);
          });
        }));
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
        user$(user);
      }
    });
  }

}
