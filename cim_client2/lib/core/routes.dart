import 'package:cim_client2/apps/showroom/showroom.dart';
import 'package:cim_client2/apps/splash/splash.dart';
import 'package:get/get.dart' hide Trans;

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
}

final List<GetPage> routes = [
  GetPage(
    name: AppRoutes.splash,
    page: () => SplashView(),
    transition: Transition.fadeIn,
    binding: BindingsBuilder.put(() => SplashViewController())
  ),
];
