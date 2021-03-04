import 'package:aqueduct/aqueduct.dart';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_token.dart';
import 'package:cim_server/model/cim_user_db.dart';
import 'package:cim_protocol/cim_protocol.dart';


class UserDeleteController extends Controller{

  UserDeleteController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try {
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMUser){
        return Response.badRequest(body: request.body);
      }
      final user = list[0] as CIMUser;

      final queryUser = Query<CIMUserDB>(context)
        ..where((x) => x.username).equalTo(user.login);
      final userDB = await queryUser.fetchOne();
      if(userDB == null){
        return Response.notFound();
      }
      await queryUser.delete();
      return Response.ok({"message" : 'User deleted'});
    }catch(e) {
      return Response.serverError(body: {"message :": e});
    }
  }
}