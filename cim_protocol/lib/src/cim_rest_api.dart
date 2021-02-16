import 'cim_user.dart';

class CIMRestApi{
  static String prepareCheckConnection() => '/checkConnection';
  static String prepareAuthToken() => '/auth/token';
  static String prepareRefreshToken() => '/auth/refresh_token';
  static String prepareNewUser() => '/user/new';
}