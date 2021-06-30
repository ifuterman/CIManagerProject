import 'package:cim_server_2/http/http.dart';
import 'package:cim_server_2/orm/orm.dart';

class TestEnpointController extends Controller {
  TestEnpointController(this.connection);

  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async {
    print('request.body.1 = ${request.body}');
    print('request.body.2 = ${request.body.asJsonMap()}');
    return Response.ok(body: request.body);
  }
}