import 'package:cim_client/views/profile/profile_page.dart';
import 'package:cim_client/views/shared/smart_nav.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController
    with SmartNavigationMixin<ProfilePageController> {

  @override
  GetPageBuilder get defaultGetPageBuilder => () => ProfilePage();

}
