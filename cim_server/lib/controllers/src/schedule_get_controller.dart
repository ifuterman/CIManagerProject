import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_doctor_db.dart';
import 'package:cim_server/model/cim_schedule_db.dart';

class ScheduleGetController extends Controller{
  ScheduleGetController(this.context);
  final  ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      final query = Query<CIMScheduleDB>(context);
      final list = await query.fetch();
      var x = list[0];
      var y = x.toSchedule(null, null);
      return Response.ok("body");
    }catch(e){
      return Response.serverError(body: {'message' : e.toString()});
    }
  }
}