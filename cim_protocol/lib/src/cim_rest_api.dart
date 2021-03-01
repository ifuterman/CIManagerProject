import 'cim_user.dart';

class CIMRestApi{
  static String prepareCheckConnection() => '/checkConnection';
  static String prepareAuthToken() => '/$authSegmentKey/token';
  static String prepareRefreshToken() => '/$authSegmentKey/refresh_token';
  static String prepareNewUser() => '/$userSegmentKey/new';
  static String prepareGetUser() => '/$userSegmentKey/get';
  static String prepareFirstUser() => '/$userSegmentKey/first';
  static String prepareUpdateUser() => '/$userSegmentKey/update';
  static String prepareDebugCleanDB() => '/$debugSegmentKey/clean_db';
  static String debugSegmentKey = 'debug';
  static String userSegmentKey = 'user';
  static String authSegmentKey = 'auth';
}