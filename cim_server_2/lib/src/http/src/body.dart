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
  final charSize;
  BodyTypes get type => _type;
  late Uint8List rawBody;
  Body(this.rawBody,[this._type = BodyTypes.raw, this.charSize = 2]);
  Body.empty():_type = BodyTypes.empty, charSize = 2{
    rawBody = Uint8List(0);
  }
  Body.fromString(String str):_type = BodyTypes.text, charSize = 2{
    var buf = Uint16List.fromList(str.codeUnits).buffer;
    rawBody = buf.asUint8List();
  }
  Body.fromMap(Map<String, dynamic> map):_type = BodyTypes.json, charSize = 2{
    var codec = JsonCodec();
    var str = codec.encode(map);
    var buf = Uint16List.fromList(str.codeUnits).buffer;
    rawBody = buf.asUint8List();
  }
    String asString() {
    List<int> list;
    if(charSize == 2){
      var offset = rawBody.buffer.lengthInBytes - rawBody.length;
      list = rawBody.buffer.asUint16List(offset);
    }
    else{
      list = rawBody.sublist(0);
    }
    var str = String.fromCharCodes(list);
    return str;
  }
  Map<String, dynamic> asJsonMap(){
    var json = asString();
    var codec = JsonCodec();
    try {
      var map = codec.decode(json);
      return map;
    }catch(e){return{};}
  }
}