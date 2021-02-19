import 'package:cim_client/views/splash/splash_page.dart';
import 'package:get/get.dart' hide Trans;

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
}

final List<GetPage> routes = [
  GetPage(
    name: AppRoutes.splash,
    page: () => SplashPage(),
    transition: Transition.fadeIn,
  ),
];
