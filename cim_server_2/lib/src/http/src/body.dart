import 'dart:convert';
import 'dart:typed_data';

enum BodyTypes{
  text,
  json,
  raw,
  empty
}

class Body{
  final BodyTypes _type;

  BodyTypes get type => _type;
  late Uint8List rawBody;
  Body(this.rawBody):_type = BodyTypes.raw;
  Body.empty():_type = BodyTypes.empty{
    rawBody = Uint8List(0);
  }
  Body.fromString(String str):_type = BodyTypes.text{
    var buf = Uint16List.fromList(str.codeUnits).buffer;
    rawBody = buf.asUint8List();
  }
  Body.fromMap(Map<String, dynamic> map):_type = BodyTypes.json{
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