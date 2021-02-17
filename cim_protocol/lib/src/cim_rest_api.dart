import 'cim_user.dart';

class CIMRestApi{
  static String prepareCheckConnection() => '/checkConnection';
  static String prepareAuthToken() => '/auth/token';
  static String prepareRefreshToken() => '/auth/refresh_token';
  static String prepareNewUser() => '/user/new';
  static String prepareGetUser() => '/user/get';
  static String prepareFirstUser() => '/user/first';
  static String prepareUpdateUser() => '/user/update';
  static String prepareDebugCleanDB() => '/debug/clean_db';
}