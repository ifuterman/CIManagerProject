import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/model/cim_doctor_db.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class DoctorUpdateController extends Controller{
  DoctorUpdateController(this.connection);
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
        ..values.speciality = doctor.speciality
        ..values.name = doctor.name
        ..values.last_name = doctor.lastName
        ..values.middle_name = doctor.middleName
        ..values.email = doctor.email
        ..values.birth_date = doctor.birthDate
        ..values.phones = doctor.phones
        ..values.users_id = doctor.userId == 0 ? null : doctor.userId
        ..where((x) => x.id).equalTo(doctor.id);
      final doctorDB = await query.updateOne();
      if(doctorDB == null){
        return Response.notFound();
      }
      doctor = doctorDB.toDoctor();
      packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create packet'}));
      }
      packet.addInstance(doctor);
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e}));
    }
  }
}