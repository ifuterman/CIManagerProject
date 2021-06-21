import 'package:cim_client2/apps/home/src/home_view_controller.dart';
import 'package:cim_client2/apps/showroom/src/show_room_view_controller.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:window_size/window_size.dart';

class GlobalService extends AppGetxService {
  static const initialRoute = AppRoutes.splash;

  final title$ = ''.obs;

  void changeTitle(String title) {
    title$(title);
    // Даже так работает!
    // setWindowTitle(title);
  }

  @override
  void onReady() {
    super.onReady();
    // F*ng easy_localization does not initializes on time.
    // So here is the trick.
    delayMilli(1000).then((_) {
      title$('title'.tr());
      if(!GetPlatform.isWeb && !GetPlatform.isMobile){
        // this way (with delaying) one can change title on Desktops
        setWindowTitle('title'.tr());
      }
    });
    // _start();
    _debugStart();
  }

  void _start() {
    delayMilli(2000).then((_) {
      SmartNavigation.put<HomeViewController>(
          HomeViewController()..offAllPage(transition: Transition.fadeIn));
    });
  }

  void _debugStart() {
    delayMilli(2000).then((_) {
      SmartNavigation.put<ShowRoomViewController>(
          ShowRoomViewController()..offAllPage(transition: Transition.fadeIn));
    });
  }
}
