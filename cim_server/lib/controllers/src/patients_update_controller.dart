import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_patient_db.dart';

class PatientsUpdateController extends Controller{
  PatientsUpdateController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try {
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      if (packet == null) {
        return Response.badRequest(body: request.body.as());
      }
      final list = packet.getInstances();
      if (list == null || list.isEmpty || list[0] is! CIMPatient) {
        return Response.badRequest(body: request.body.as());
      }
      var patient = list[0] as CIMPatient;
      final query = Query<CIMPatientDB>(context)
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
      final patinetDB = await query.updateOne();
      if(patinetDB == null){
        Response.notFound();
      }
      patient = patinetDB.toPatient();
      packet = CIMPacket.makePacket();
      packet.addInstance(patient);
      return Response.ok(packet.map);
    }catch(e){
      return Response.serverError(body : {'message' : e});
    }
  }
}