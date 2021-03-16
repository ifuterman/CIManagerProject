import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_doctor_db.dart';
import 'package:cim_server/model/cim_patient_db.dart';
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
      CIMDoctor doctor;
      if(schedule.doctor != null) {
        final queryDoctor = Query<CIMDoctorDB>(context)
          ..where((x) => x.id == schedule.doctor.id);
        final doctorDB = await queryDoctor.fetchOne();
        if(doctorDB == null) {
          packet = CIMPacket.makePacket();
          return Response(HttpStatus.expectationFailed, {}, request.body.as());
        }
        doctor = doctorDB.toDoctor();
        if(doctor != schedule.doctor) {
          return Response(HttpStatus.expectationFailed, {}, request.body.as());
        }
      }
      final queryPatient = Query<CIMPatientDB>(context)
        ..where((x) => x.id == schedule.patient.id);
      final patientDB = await queryPatient.fetchOne();
      if(patientDB == null){
        return Response(HttpStatus.expectationFailed, {}, request.body.as());
      }
      final patient = patientDB.toPatient();
      if(patient != schedule.patient){
        return Response(HttpStatus.expectationFailed, {}, request.body.as());
      }

      final query = Query<CIMScheduleDB>(context)
        ..values.duration = schedule.duration
        ..values.date = schedule.date
        ..values.note = schedule.note
        ..values.doctor_id = schedule.doctor.id
        ..values.patient_id = schedule.patient.id;

      final scheduleDB = await query.insert();
      if(scheduleDB == null){
        return Response.forbidden();
      }
      schedule = scheduleDB.toSchedule(patient, doctor);
      packet = CIMPacket.makePacket();
      packet.addInstance(schedule);
      return Response.ok(packet.map);
    }catch(e){
      return Response.serverError(body: {'message' : e.toString()});
    }
  }
}