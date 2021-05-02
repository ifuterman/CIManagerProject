import 'package:cim_client2/core/getx_helpers.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

import 'home_view.dart';
import 'show_room_view_controller.dart';

class HomeViewController extends AppGetxController
    with SmartNavigationMixin<HomeViewController> {
  @override
  get defaultGetPageBuilder => () => HomeView();

  final state = State.home;
}
