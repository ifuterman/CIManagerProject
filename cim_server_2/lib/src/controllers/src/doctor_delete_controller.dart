import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/model/cim_doctor_db.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class DoctorDeleteController extends Controller{
  DoctorDeleteController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(body: Body.fromMap({'reason' : 'No instances found'}));
      }
      var doctor = list[0] as CIMDoctor;
      final query = Query<CIMDoctorDB>(connection)
        ..where((x) => x.id).equalTo(doctor.id);
      final count = await query.delete();
      if(count == 0){
        return Response.notFound();
      }
      return Response.ok(body: Body.fromMap({'message' : 'deleted'}));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e}));
    }
  }
}