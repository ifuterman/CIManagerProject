import 'package:cim_protocol/cim_protocol.dart';
import 'cim_json_mapper_0_0_1.dart';

/*
* Нельзя изменять назначение и тип полей для совместимости разных версий протокола
* */

class CIMJsonMapper{
  static const String lastVersion = '0.0.1';
  static const versionKey = 'version';
  static const instanceKey = 'instance';
  static const cimUserKey = 'CIMUser';
  static final _mapperVersions = <String, CIMJsonMapper>{
    '0.0.1' : CIMJsonMapper_0_0_1()
  };
  String getVersion() => throw UnimplementedError();
  void userToMap(CIMUser user, Map<String, String> map) => throw UnimplementedError();
  CIMUser userFromMap(Map<String, String> map) => throw UnimplementedError();

  static CIMJsonMapper getMapper([String version = lastVersion]) => _mapperVersions[version];

    Map<String,String> toMap<T>(T instance){
    final map = {versionKey : getVersion()};
    if(instance is CIMUser){
      map[instanceKey] = cimUserKey;
      userToMap(instance, map);
    }
    else{
      return null;
    }
    return map;
  }

  static dynamic fromMap(Map<String, String> map){
    try {
      final version = map[versionKey];
      if(version == null){
        return null;
      }
      var mapper = getMapper(version);
      mapper ??= getMapper();
      final instance = map[instanceKey];
      if(instance == null) {
        return null;
      }
      switch(instance){
        case cimUserKey:{
          return mapper.userFromMap(map);
        }
      }
    }catch (e){
      return null;
    }
  }
  static bool isSupported(String ver) => _mapperVersions[ver] != null;
}