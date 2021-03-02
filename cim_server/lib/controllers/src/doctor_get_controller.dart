import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_doctor_db.dart';

class DoctorGetController extends Controller{
  DoctorGetController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try {
      final query = Query<CIMDoctorDB>(context);
      final list = await query.fetch();
      if (list.isEmpty) {
        return Response.noContent();
      }
      final packet = CIMPacket.makePacket();
      for (var doctor in list) {
        packet.addInstance(doctor.toDoctor());
      }
      return Response.ok(packet.map);
    }catch(e){
      return Response.serverError(body: {'message' : e});
    }
  }
}