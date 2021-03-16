import 'package:cim_client/views/profile/profile_page.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

class ProfilePageController extends GetxController
    with SmartNavigationMixin<ProfilePageController> {

  @override
  GetPageBuilder get defaultGetPageBuilder => () => ProfilePage();

}
