import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/model/cim_patient_db.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/http/http.dart';

class PatientsGetController extends Controller{
  PatientsGetController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try {
      final query = Query<CIMPatientDB>(connection);
      final list = await query.select();
      if (list.isEmpty) {
        return Response.noContent();
      }
      final packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create packet'}));
      }
      for (var patient in list) {
        packet.addInstance(patient.toPatient());
      }
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e}));
    }
  }
}