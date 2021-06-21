import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/model/cim_patient_db.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class PatientsDeleteController extends Controller{
  PatientsDeleteController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMPatient){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final patient = list[0] as CIMPatient;
      final query = Query<CIMPatientDB>(connection)
        ..where((x) => x.id).equalTo(patient.id);
      final res = await query.delete();
      if(res <= 0){
        return Response.notFound();
      }
      return Response.ok(body: Body.fromMap({'message' : 'deleted'}));
    }catch(e){
      return Response.internalServerError(body : Body.fromMap({'message' : e}));
    }
  }
}