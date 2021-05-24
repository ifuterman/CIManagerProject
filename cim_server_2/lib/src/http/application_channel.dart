import 'package:cim_server_2/src/http/http_processor.dart';
import 'package:cim_server_2/src/http/router.dart';

abstract class ApplicationChannel extends HttpProcessor{
  void prepare(){}
  void finalise(){}
  Router getEndpoint();
}