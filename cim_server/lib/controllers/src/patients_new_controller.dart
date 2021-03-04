import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_patient_db.dart';

class PatientsNewController extends Controller{
  PatientsNewController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle (Request request) async{
    try{
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      if(packet == null){
        return Response.badRequest(body: request.body);
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMPatient){
        return Response.badRequest(body: request.body);
      }
      var patient = list[0] as CIMPatient;
      var query = Query<CIMPatientDB>(context)
        ..where((x) => x.snils).isNotNull()
        ..where((x) => x.snils).equalTo(patient.snils);
      var patientDB = await query.fetchOne();
      if(patientDB != null){
        return Response.conflict();
      }
      query = Query<CIMPatientDB>(context)
        ..where((x) => x.name).equalTo(patient.name)
        ..where((x) => x.middle_name).equalTo(patient.middleName)
        ..where((x) => x.last_name).equalTo(patient.lastName)
        ..where((x) => x.birth_date).equalTo(patient.birthDate);
      patientDB = await query.fetchOne();
      if(patientDB != null){
        return Response.conflict();
      }
      query = Query<CIMPatientDB>(context)
        ..values.name = patient.name
        ..values.middle_name = patient.middleName
        ..values.last_name = patient.lastName
        ..values.birth_date = patient.birthDate
        ..values.snils = patient.snils
        ..values.phone = patient.phones
        ..values.email = patient.email
        ..values.status = patient.status
        ..values.sex = patient.sex;
      patientDB = await query.insert();
      patient = patientDB.toPatient();
      packet = CIMPacket.makePacket();
      packet.addInstance(patient);
      return Response.ok(packet.map);
    }catch(e){
      return Response.serverError(body : {'message' : e});
    }
  }
}