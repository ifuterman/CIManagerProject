import 'package:cim_server_2/src/http/application_channel.dart';
import 'package:cim_server_2/src/http/controller.dart';
import 'package:cim_server_2/src/http/request.dart';
import 'package:cim_server_2/src/http/request_or_response.dart';
import 'package:cim_server_2/src/http/response.dart';
import 'package:cim_server_2/src/http/router.dart';

class TestController extends Controller{
  @override
  RequestOrResponse handle(Request request) {
    return Response.ok();
  }
  
}

class AppChannel extends ApplicationChannel{
  @override
  Router getEndpoint() {
    var router = Router();
    router.route('debug/clean_db')
        .link(() => TestController());
    return router;
  }

}