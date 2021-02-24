import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_token.dart';
import 'package:cim_server/model/cim_user_db.dart';
import 'package:cim_protocol/cim_protocol.dart';

class CheckRoleController extends Controller{
  CheckRoleController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try {
      var token = request.raw.headers[HttpHeaders.authorizationHeader]
          .toString();
      final list = token.split(' ');
      if(list == null || list.length != 2){
        return Response.badRequest();
      }
      token = list[1];
      token = token.replaceAll(']', '');
      final queryToken = Query<CIMToken>(context)
        ..where((x) => x.token).equalTo(token);
      final tokenObj = await queryToken.fetchOne();
      final queryUser = Query<CIMUserDB>(context)
        ..where((x) => x.id).equalTo(tokenObj.users_id);
      final user = await queryUser.fetchOne();
      UserRoles role = user
          .toUser()
          .role;
      if (role == UserRoles.administrator)
        return request;
      if (role == UserRoles.doctor) {
        if (request.path.segments[0] == CIMRestApi.userSegmentKey &&
            request.path.segments[1] != 'get') {
          return Response.forbidden();
        }
        return request;
      }
    }catch(e){
      return Response.serverError(body: {'message' : e.toString()});
    }
    return Response.forbidden();
  }
}