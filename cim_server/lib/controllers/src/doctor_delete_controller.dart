import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_doctor_db.dart';

class DoctorDeleteController extends Controller{
  DoctorDeleteController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(headers: {"reason" : "No instances found"});
      }
      var doctor = list[0] as CIMDoctor;
      final query = Query<CIMDoctorDB>(context)
        ..where((x) => x.id).equalTo(doctor.id);
      final int count = await query.delete();
      if(count == 0){
        return Response.notFound();
      }
      return Response.ok({'message' : 'deleted'});
    }catch(e){
      return Response.serverError(body: {'message' : e});
    }
  }
}