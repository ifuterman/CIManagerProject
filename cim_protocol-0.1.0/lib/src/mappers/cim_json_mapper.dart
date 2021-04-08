import 'package:cim_protocol/cim_protocol.dart';
//import 'package:cim_protocol/src/cim_schedule.dart';
import 'cim_json_mapper_0_0_1.dart';

/*
* Нельзя изменять назначение и тип полей для совместимости разных версий протокола
* */

class CIMJsonMapper{
  static const String lastVersion = '0.0.1';
  static const versionKey = 'version';
  static const instanceKey = 'instance';
  static const instancesKey = 'instances';
  static const cimUserKey = 'CIMUser';
  static const cimDoctorKey = 'CIMDoctor';
  static const cimPatientKey = 'CIMPatient';
  static const cimScheduleKey = 'CIMSchedule';
  static final _mapperVersions = <String, CIMJsonMapper>{
    '0.0.1' : CIMJsonMapper_0_0_1()
  };
  String getVersion() => throw UnimplementedError();
  void userToMap(CIMUser user, Map<String, dynamic> map) => throw UnimplementedError();
  CIMUser? userFromMap(Map<String, dynamic> map) => throw UnimplementedError();
  void doctorToMap(CIMDoctor doctor, Map<String, dynamic> map) => throw UnimplementedError();
  CIMDoctor? doctorFromMap(Map<String, dynamic> map) => throw UnimplementedError();
  void patientToMap(CIMPatient patient, Map<String, dynamic> map) => throw UnimplementedError();
  CIMPatient? patientFromMap(Map<String, dynamic> map) => throw UnimplementedError();
  void scheduleToMap(CIMSchedule schedule, Map<String, dynamic> map) => throw UnimplementedError();
  CIMSchedule? scheduleFromMap(Map<String, dynamic> map) => throw UnimplementedError();


  static CIMJsonMapper? getMapper([String version = lastVersion]) => _mapperVersions[version];

  Map<String, String> getInitialHeaders() => {versionKey : getVersion()};

  Map<String,dynamic>? instanceToMap<T>(T instance){
    var map = <String, dynamic>{};
    if(instance is CIMUser){
      map[instanceKey] = cimUserKey;
      userToMap(instance, map);
    }
    else if(instance is CIMDoctor){
      map[instanceKey] = cimDoctorKey;
      doctorToMap(instance, map);
    }
    else if(instance is CIMPatient){
      map[instanceKey] = cimPatientKey;
      patientToMap(instance, map);
    }
    else if(instance is CIMSchedule){
      map[instanceKey] = cimScheduleKey;
      scheduleToMap(instance, map);
    }
    else{
      return null;
    }
    return map;
  }

  static String getVersionFromMap(Map<String,dynamic> map){
    return map[versionKey];
  }

  dynamic? fromMap(Map<String, dynamic> map){
    try {
      final instance = map[instanceKey];
      if(instance == null) {
        return null;
      }
      switch(instance){
        case cimUserKey:{
          return userFromMap(map);
        }
        case cimDoctorKey:{
          return doctorFromMap(map);
        }
        case cimPatientKey:{
          return patientFromMap(map);
        }
        case cimScheduleKey:{
          return scheduleFromMap(map);
        }
      }
    }catch (e){
      return null;
    }
  }
  static bool isSupported(String ver) => _mapperVersions[ver] != null;
}