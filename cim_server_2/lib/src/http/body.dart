import 'dart:convert';
import 'dart:typed_data';

class Body{
  late Uint8List rawBody;
  Body(this.rawBody);
  Body.empty(){
    rawBody = Uint8List(0);
  }
  Body.fromString(String str){
    var buf = Uint16List.fromList(str.codeUnits).buffer;
    rawBody = buf.asUint8List();
  }
  Body.fromMap(Map<String, dynamic> map){
    var codec = JsonCodec();
    var str = codec.encode(map);
    var buf = Uint16List.fromList(str.codeUnits).buffer;
    rawBody = buf.asUint8List();
  }
  String asString(){
    var buf = rawBody.buffer;
    return String.fromCharCodes(buf.asUint16List());
  }
  Map<String, dynamic> asJsonMap(){
    var json = asString();
    var codec = JsonCodec();
    try {
      var map = codec.decode(json);
      return map;
    }catch(e){
      return {};
    }
  }
}