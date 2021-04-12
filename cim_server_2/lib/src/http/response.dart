import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:cim_server_2/src/http/body.dart';

class Response{
  int status;
  late Body body;
  Response(this.status, this.body);
  Response.badRequest(Body body):this.status = HttpStatus.badRequest{
    var codec = JsonCodec();
    var str = codec.encoder.convert(body);
    Uint8List.fromList(str.codeUnits);
  }
}