import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/model/cim_schedule_db.dart';
import 'package:cim_server_2/http/http.dart';
import 'package:cim_server_2/orm/orm.dart';

class ScheduleGetController extends Controller{
  ScheduleGetController(this.connection);
  final  Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      final query = Query<CIMScheduleDB>(connection);
      final list = await query.select();
      var packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create CIMPacket'}));
      }
      for(var schedule in list){
        packet.addInstance(schedule);
      }
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e.toString()}));
    }
  }
}