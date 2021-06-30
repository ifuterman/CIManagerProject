import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/http/http.dart';
import 'package:cim_server_2/model/cim_patient_db.dart';

class PatientsNewController extends Controller{
  PatientsNewController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle (Request request) async{
    try{
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMPatient){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      var patient = list[0] as CIMPatient;
      var query = Query<CIMPatientDB>(connection)
        ..where((x) => x.snils).isNotNull()
        ..where((x) => x.snils).equalTo(patient.snils);
      var patientDB = await query.selectOne();
      if(patientDB != null){
        return Response.conflict();
      }
      query = Query<CIMPatientDB>(connection)
        ..where((x) => x.name).equalTo(patient.name)
        ..where((x) => x.middle_name).equalTo(patient.middleName)
        ..where((x) => x.last_name).equalTo(patient.lastName)
        ..where((x) => x.birth_date).equalTo(patient.birthDate);
      patientDB = await query.selectOne();
      if(patientDB != null){
        return Response.conflict();
      }
      query = Query<CIMPatientDB>(connection)
        ..values.name = patient.name
        ..values.middle_name = patient.middleName
        ..values.last_name = patient.lastName
        ..values.birth_date = patient.birthDate
        ..values.snils = patient.snils
        ..values.phone = patient.phones
        ..values.email = patient.email
        ..values.status = patient.status
        ..values.sex = patient.sex;
      patientDB = await query.insertOne();
      if(patientDB == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t insert to DB'}));
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