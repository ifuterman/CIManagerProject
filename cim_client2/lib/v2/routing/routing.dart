import 'package:cim_client2/v2/apps/connect/connect.dart';
import 'package:cim_client2/v2/apps/main/main.dart';
import 'package:cim_client2/v2/apps/splash/splash.dart';

class RouteNames {
  static const splash = SplashView.pageTitle;
  static const main = MainView.pageTitle;
  static const connect = ConnectView.pageTitle;
}

class NestedTabRoutes {
  static const patients = 0;
}

final routes = [
  SplashView.page,
  MainView.page,
  ConnectView.page,
];
