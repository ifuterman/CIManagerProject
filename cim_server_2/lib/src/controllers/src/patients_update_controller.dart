import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/model/cim_patient_db.dart';

class PatientsUpdateController extends Controller{
  PatientsUpdateController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try {
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if (packet == null) {
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if (list == null || list.isEmpty || list[0] is! CIMPatient) {
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      var patient = list[0] as CIMPatient;
      final query = Query<CIMPatientDB>(connection)
      ..values.sex = patient.sex
      ..values.status = patient.status
      ..values.email = patient.email
      ..values.phone = patient.phones
      ..values.snils = patient.snils
      ..values.birth_date = patient.birthDate
      ..values.last_name = patient.lastName
      ..values.middle_name = patient.middleName
      ..values.name = patient.name
      ..where((x) => x.id).equalTo(patient.id);
      final patientDB = await query.updateOne();
      if(patientDB == null){
        return Response.notFound();
      }
      patient = patientDB.toPatient();
      packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create packet'}));
      }
      packet.addInstance(patient);
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e){
      return Response.internalServerError(body : Body.fromMap({'message' : e}));
    }
  }
}