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
  static String prepareDebugDeleteUsers() => '/$debugSegmentKey/delete_users';
  static String prepareDoctorNew() => '/$doctorSegmentKey/new';
  static String prepareDoctorGet() => '/$doctorSegmentKey/get';
  static String prepareDoctorUpdate() => '/$doctorSegmentKey/update';
  static String prepareDoctorDelete() => '/$doctorSegmentKey/delete';
  static String preparePatientsDelete() => '/$patientsSegmentKey/delete';
  static String preparePatientsGet() => '/$patientsSegmentKey/get';
  static String preparePatientsNew() => '/$patientsSegmentKey/new';
  static String preparePatientsUpdate() => '/$patientsSegmentKey/update';
  static String debugSegmentKey = 'debug';
  static String userSegmentKey = 'user';
  static String authSegmentKey = 'auth';
  static String doctorSegmentKey = 'doctor';
  static String patientsSegmentKey = 'patients';
}