import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_patient_db.dart';

class PatientsGetController extends Controller{
  PatientsGetController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try {
      final query = Query<CIMPatientDB>(context);
      final list = await query.fetch();
      if (list.isEmpty) {
        return Response.noContent();
      }
      final packet = CIMPacket.makePacket();
      for (var patient in list) {
        packet.addInstance(patient.toPatient());
      }
      return Response.ok(packet.map);
    }catch(e){
      return Response.serverError(body: {'message' : e});
    }
  }
}