import 'http_processor.dart';
import 'router.dart';

abstract class ApplicationChannel extends HttpProcessor{
  void prepare(){}
  void finalise(){}
  Router getEndpoint();
}