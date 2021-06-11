import 'dart:convert';
import 'dart:io' as http;

import 'dart:io';


class HttpClient{
  String host;
  int port;
  var client = http.HttpClient();
  HttpClient(this.host, this.port){
  }
  Future<Response> get(String url) async{

    var request = await client.get(host, port, url);
//    request.headers.contentType = new http.ContentType("application", "json", charset: "utf-8");
    var response = await request.close();
    var res = Response(response);
    await res.parse();
//    client.close();
    return res;
  }
  Future<Response> post(String url, Request request) async {
    print('post 1');
    var client = http.HttpClient();
    print('post 2');
    var httpRequest = await client.post(host, port, url);
    print('post 3');
//    httpRequest.headers.contentType = new http.ContentType("application", "json", charset: "utf-8");
    httpRequest.headers.contentType = new http.ContentType("application", "json");
    String str = request.asString();
    httpRequest.contentLength = str.length;
    httpRequest.write(str);
    print('post 4');
    sleep(Duration(seconds: 3));
    var x = await httpRequest.flush();
    print('post 5: $x');
    var response = await httpRequest.close();
//    client.close();
    print('post 6');
    var res = Response(response);
    var body = await res.parse();

    print('${body?.asString()}');
    return res;
  }
}

class Request{
  Map<String, dynamic> requestMap = {};
  Map <String, dynamic> get jsonMap => requestMap;
  Request(){}
  Request.json(Map<String, dynamic> map){
    requestMap.addAll(map);
  }
  String asString(){
    try {
      var codec = JsonCodec();
      return codec.encode(jsonMap);
    }catch (e){return '';}
  }
}

class Response{
  List<int> rawBody = List.empty();
  http.HttpClientResponse _response;
  Response(this._response) {
  }
  Future<Body?> parse() async{
    if(_response.contentLength == 0){
      return null;
    }
    rawBody = await _response.first;
    return Body(rawBody);
  }
  http.HttpHeaders get headers => _response.headers;
  int get statusCode => _response.statusCode;
  int get contentLength => _response.contentLength;
}

class Body{
  List<int> rawBody;
  Body(this.rawBody);
  String asString(){
    return String.fromCharCodes(rawBody);
  }
  Map asMap(){
    try {
      JsonCodec codec = new JsonCodec();
      return codec.decoder.convert(asString());
    }catch(e){return {};}
  }
}