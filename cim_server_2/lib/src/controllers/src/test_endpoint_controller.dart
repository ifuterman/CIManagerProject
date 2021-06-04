import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/orm/orm.dart';

class TestEnpointController extends Controller {
  TestEnpointController(this.connection);

  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async {
    return Response.ok(body: Body.fromMap(request.body.asJsonMap()));
  }
}