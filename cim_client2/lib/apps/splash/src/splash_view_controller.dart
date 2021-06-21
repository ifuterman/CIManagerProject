import 'package:cim_client2/apps/showroom/showroom.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

import 'splash_view.dart';

class SplashViewController extends AppGetxController
    with SmartNavigationMixin<SplashViewController> {

  @override
  get defaultGetPageBuilder => () => SplashView();

  final state = State.splash;
}
