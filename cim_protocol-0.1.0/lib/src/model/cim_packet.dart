import 'dart:convert';
import 'dart:core';

import 'package:cim_protocol/src/mappers/cim_json_mapper.dart';

class CIMPacket {
  final CIMJsonMapper _mapper;
  final Map<String, dynamic> _map = <String, dynamic>{};

  Map<String, dynamic> get map => Map.from(_map);

  CIMPacket(this._mapper){
    _map.addAll(_mapper.getInitialHeaders());
  }

  static CIMPacket? makePacket([String version = CIMJsonMapper.lastVersion])
  {
    var mapper = CIMJsonMapper.getMapper(version);
    if(mapper == null) {
      return null;
    }
    return CIMPacket(mapper);
  }
  bool addInstance<T>(T instance){
    var map = _mapper.instanceToMap(instance);
    if(map == null) {
      return false;
    }
    var list = _map[CIMJsonMapper.instancesKey];
    if(list == null) {
      list = List<Map<String, dynamic>>.empty(growable: true);
      _map[CIMJsonMapper.instancesKey] = list;
    }
    list.add(map);
    return true;
  }
  static CIMPacket? makePacketFromMap(Map<String, dynamic> map){
    var packet = makePacket(CIMJsonMapper.getVersionFromMap(map));
    if(packet == null) {
      return null;
    }
    packet._map.addAll(map);
    return packet;
  }

  static CIMPacket? fromJson(String json){
    try {
      var map = JsonDecoder().convert(json);
      return makePacketFromMap(map);
    }catch(e){return null;}
  }

  List<dynamic>? getInstances() {
    var list = _map[CIMJsonMapper.instancesKey];
    if(list == null) {
      return null;
    }
    var res = List<dynamic>.empty(growable: true);
    for(var map in list){
      var instance = _mapper.fromMap(map);
      if(instance != null){
        res.add(instance);
      }
    }
    return res;
  }
  String getVersion() => _mapper.getVersion();
  String toJson(){
    return JsonEncoder().convert(_map);
  }
}