import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_schedule_db.dart';

class ScheduleAddController extends Controller{
  ScheduleAddController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      var list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] == null || list[0] is! CIMSchedule ){
        return Response.badRequest(body: request.body.as());
      }
      var schedule = list[0] as CIMSchedule;
      final query = Query<CIMScheduleDB>(context)
        ..values.id = schedule.id
        ..values.duration = schedule.duration
        ..values.date = schedule.date
        ..values.note = schedule.note
        ..values.doctor_id = schedule.doctor.id
        ..values.patient_id = schedule.patient.id;
      final scheduleDB = query.insert();
      if(scheduleDB == null){
        return Response.forbidden();
      }
    }catch(e){
      return Response.serverError(body: {'message' : e.toString()});
    }
  }
}