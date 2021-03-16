import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_patient_db.dart';

class PatientsDeleteController extends Controller{
  PatientsDeleteController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      if(packet == null){
        return Response.badRequest(body: request.body.as());
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMPatient){
        return Response.badRequest(body: request.body.as());
      }
      final patient = list[0] as CIMPatient;
      final query = Query<CIMPatientDB>(context)
        ..where((x) => x.id).equalTo(patient.id);
      final res = await query.delete();
      if(res <= 0){
        return Response.notFound();
      }
      return Response.ok({'message' : 'deleted'});
    }catch(e){
      return Response.serverError(body : {'message' : e});
    }
  }
}