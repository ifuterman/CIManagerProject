import 'dart:io';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/model/cim_doctor_db.dart';
import 'package:cim_server_2/model/cim_patient_db.dart';
import 'package:cim_server_2/model/cim_schedule_db.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/http/http.dart';

class ScheduleAddController extends Controller{
  ScheduleAddController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: request.body);
      }
      var list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] == null || list[0] is! CIMSchedule ){
        return Response.badRequest(body: request.body);
      }
      var schedule = list[0] as CIMSchedule;
      CIMDoctor? doctor;
      if(schedule.doctor != null) {
        final queryDoctor = Query<CIMDoctorDB>(connection)
          ..where((x) => x.id == schedule.doctor!.id);
        final doctorDB = await queryDoctor.selectOne();
        if(doctorDB == null) {
          return Response(HttpStatus.expectationFailed, Body.fromMap({'message':'Doctor not found in DB'}));
        }
        doctor = doctorDB.toDoctor();
        if(doctor != schedule.doctor) {
          return Response(HttpStatus.expectationFailed, Body.fromMap({'message':'Doctor data in DB differs'}));
        }
      }
      final queryPatient = Query<CIMPatientDB>(connection)
        ..where((x) => x.id == schedule.patient.id);
      final patientDB = await queryPatient.selectOne();
      if(patientDB == null){
        return Response.notFound(body: Body.fromMap({'message' : 'Patinet not found'}));
      }
      final patient = patientDB.toPatient();
      if(patient != schedule.patient){
        return Response(HttpStatus.expectationFailed, Body.fromMap({'message':'Doctor data in DB differs'}));
      }
      final query = Query<CIMScheduleDB>(connection)
        ..values.duration = schedule.duration
        ..values.date = schedule.date
        ..values.note = schedule.note
        ..values.doctor_id = schedule.doctor == null ? 0 : schedule.doctor!.id
        ..values.patient_id = schedule.patient.id;

      final scheduleDB = await query.insertOne();
      if(scheduleDB == null){
        return Response.forbidden();
      }
      schedule = scheduleDB.toSchedule(patient, doctor);
      packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create CIMPacket'}));
      }
      packet.addInstance(schedule);
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e.toString()}));
    }
  }
}