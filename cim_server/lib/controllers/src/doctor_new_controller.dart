import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_doctor_db.dart';


class DoctorNewController extends Controller{
  DoctorNewController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    try {
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(headers: {"reason" : "No instances found"});
      }
      var doctor = list[0] as CIMDoctor;
      final query = Query<CIMDoctorDB>(context)
        ..values.speciality = doctor.speciality
        ..values.name = doctor.name
        ..values.last_name = doctor.lastName
        ..values.middle_name = doctor.middleName
        ..values.email = doctor.email
        ..values.birth_date = doctor.birthDate
        ..values.phones = doctor.phones
        ..values.users_id = doctor.userId;
      final doctorDB = await query.insert();
      doctor = doctorDB.toDoctor();
      packet = CIMPacket.makePacket();
      if(!packet.addInstance(doctor)){
        return Response.serverError(body : {"message" : "add instance problem"});
      }
      return Response.ok(packet.map);
    }catch(e) { return Response.serverError(body : {"message" : e.toString()});}
  }
}