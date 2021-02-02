
import '../cim_protocol.dart';
import '../cim_protocol.dart';
import '../cim_protocol.dart';

class CIMJsonMapper{
  final _mapperVersions = <String, CIMJsonMapper>{
    "0.0.1" : CIMJsonMapper()
  };

  static Map<String,String> toMap<T>(T instance){
    final map = {"ver" : "1"};
    switch(T.runtimeType){
      case CIMUser:
        {
          userToMap(instance as CIMUser, map);
          break;
        }
    }
    return map;
  }

  static  void userToMap(CIMUser user, Map<String, String> map)
  {
    map["instance"] = "CIMUser";
  }

  static dynamic fromMap(Map<String, String> map){
    try {
      final version = map["ver"];
      if(version == null)
        return null;
      if(!isSupported(version))
        return null;

    }catch (e){
      return null;
    }
  }
  static bool isSupported(String ver){
    var list = ver.split(".");
    if(list.length != 3)
      return false;

    return true;
  }
}

class CIMJsonMapper_0_0_1 {
}