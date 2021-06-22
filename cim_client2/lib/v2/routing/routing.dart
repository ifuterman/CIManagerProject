import 'package:cim_client2/v2/apps/main/main.dart';
import 'package:cim_client2/v2/apps/splash/splash.dart';

class RouteNames {
  static const splash = SplashView.pageTitle;
  static const main = MainView.pageTitle;
}

class NestedTabRoutes {
  static const patients = 0;
}

final routes = [
  SplashView.page,
  MainView.page,
];
