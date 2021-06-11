import 'dart:convert';
import 'dart:io';

enum BodyTypes{
  text,
  json,
  raw,
  empty,
  error
}

class Body{
  final BodyTypes _type;
//  final charSize;
  BodyTypes get type => _type;
  String strBody = '';
//  late Uint8List rawBody;
//  Body(this.rawBody,[this._type = BodyTypes.raw, this.charSize = 2]);
  Body ._(this._type);
  static Future<Body> makeBody(HttpRequest request) async{
    if(request.contentLength == 0){
      return Body._(BodyTypes.empty);
    }
    try{
      var bytes = await request.first;
      if(bytes.isEmpty){
        return Body._(BodyTypes.empty);
      }
      if(request.headers.contentType == ContentType.text){
        var body = Body._(BodyTypes.text);
        body.strBody = Utf8Decoder().convert(bytes);
        return body;
      }
      if(request.headers.contentType == ContentType.json){
        var body = Body._(BodyTypes.json);
        body.strBody = Utf8Decoder().convert(bytes);
        return body;
      }
      var body = Body._(BodyTypes.raw);
      body.strBody = String.fromCharCodes(bytes);
      return body;

    }catch(e){return Body._(BodyTypes.error);}
  }
  Body.empty():_type = BodyTypes.empty;
  Body.fromString(this.strBody):_type = BodyTypes.text;

  Body.fromMap(Map<String, dynamic> map):_type = BodyTypes.json{
    var codec = JsonCodec();
    strBody = codec.encode(map);
  }
    String asString() {
    return strBody;
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