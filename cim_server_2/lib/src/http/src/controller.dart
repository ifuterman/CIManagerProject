import 'request.dart';
import 'request_or_response.dart';

abstract class Controller{
  Future<RequestOrResponse> handle(Request request);
}