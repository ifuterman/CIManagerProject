import 'package:cim_server_2/src/http/request.dart';
import 'package:cim_server_2/src/http/request_or_response.dart';

abstract class Controller{
  RequestOrResponse handle(Request request);
}