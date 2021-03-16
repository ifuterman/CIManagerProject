import 'package:cim_protocol/cim_protocol.dart';

import 'harness/app.dart';
Future main() async {
  CIMAuthorisationInfo aInfo;
  String token;
  final String authKey = 'Authorization';
  var authorisation = <String, String>{};
  final user = CIMUser('admin', 'admin',);
  user.role = UserRoles.administrator;

  var doctor = CIMDoctor('Test', 'TEST', DoctorSpeciality.therapist, email: 'test@mail.ru', phones: '+79122534222');
  var patient = CIMPatient(0, 'testPatient', 'testPatientName', Sex.male);

  final harness = Harness()..install();
  test('check connection', () async{
    final response = await harness.agent.get(CIMRestApi.prepareCheckConnection());
    expectResponse(response, 200);
  });

  test('get token', ()async{
    final packet = CIMPacket.makePacket();
    packet.addInstance(user);
    final response = await harness.agent.post(CIMRestApi.prepareAuthToken(), body: packet.map);
    expectResponse(response, 200);
    await response.body.decode();
    aInfo = CIMAuthorisationInfo.fromMap(response.body.as());
    token = 'Bearer ${aInfo.token}';
    authorisation = {authKey : token};
  });

  test('test add doctor', ()async{
    var packet = CIMPacket.makePacket();
    packet.addInstance(doctor);
    final response = await harness.agent.post(CIMRestApi.prepareDoctorNew(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
    await response.body.decode();
    packet = CIMPacket.makePacketFromMap(response.body.as());
    expect(packet, isNotNull);
    final list = packet.getInstances();
    expect(list, isNotNull);
    expect(true, list.isNotEmpty);
    final instance = list[0];
    expect(true, instance is CIMDoctor);
    doctor = instance as CIMDoctor;
  });

  test('test update doctor', ()async{
    var packet = CIMPacket.makePacket();
    doctor.name = 'newDoctorName';
    packet.addInstance(doctor);
    final response = await harness.agent.post(CIMRestApi.prepareDoctorUpdate(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
    await response.body.decode();
    packet = CIMPacket.makePacketFromMap(response.body.as());
    expect(packet, isNotNull);
    final list = packet.getInstances();
    expect(list, isNotNull);
    expect(true, list.isNotEmpty);
    final instance = list[0];
    expect(true, instance is CIMDoctor);
    final doctorUpdated = instance as CIMDoctor;
    expect(true, doctorUpdated == doctor);
  });

  test('test get doctor', ()async{
    final response = await harness.agent.get(CIMRestApi.prepareDoctorGet(),headers: authorisation);
    expectResponse(response, 200);
    await response.body.decode();
    final packet = CIMPacket.makePacketFromMap(response.body.as());
    expect(packet, isNotNull);
    final list = packet.getInstances();
    expect(list, isNotNull);
    expect(true, list.isNotEmpty);
    var flag = false;
    for(var instance in list){
      if(instance == null){
        break;
      }
      if(instance is! CIMDoctor){
        break;
      }
      final d = instance;
      if(d == doctor){
        flag = true;
        break;
      }
    }
    expect(true, flag);
  });

  test('test add patient', ()async{
    var packet = CIMPacket.makePacket();
    packet.addInstance(patient);
    final response = await harness.agent.post(CIMRestApi.preparePatientsNew(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
    await response.body.decode();
    packet = CIMPacket.makePacketFromMap(response.body.as());
    expect(packet, isNotNull);
    final list = packet.getInstances();
    expect(list, isNotNull);
    expect(true, list.isNotEmpty);
    final instance = list[0];
    expect(true, instance is CIMPatient);
    patient = instance as CIMPatient;
  });

  test('test update patient', ()async{
    var packet = CIMPacket.makePacket();
    patient.name = 'newTestPatientName';
    packet.addInstance(patient);
    final response = await harness.agent.post(CIMRestApi.preparePatientsUpdate(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
    await response.body.decode();
    packet = CIMPacket.makePacketFromMap(response.body.as());
    expect(packet, isNotNull);
    final list = packet.getInstances();
    expect(list, isNotNull);
    expect(true, list.isNotEmpty);
    final instance = list[0];
    expect(true, instance is CIMPatient);
    final patientUpdated = instance as CIMPatient;
    expect(true, patientUpdated == patient);
  });

  test('test get patient', ()async{
    final response = await harness.agent.get(CIMRestApi.preparePatientsGet(),headers: authorisation);
    expectResponse(response, 200);
    await response.body.decode();
    final packet = CIMPacket.makePacketFromMap(response.body.as());
    expect(packet, isNotNull);
    final list = packet.getInstances();
    expect(list, isNotNull);
    expect(true, list.isNotEmpty);
    var flag = false;
    for(var instance in list){
      if(instance == null){
        break;
      }
      if(instance is! CIMPatient){
        break;
      }
      final p = instance;
      if(p == patient){
        flag = true;
        break;
      }
    }
    expect(true, flag);
  });
  
  test('test delete patient', ()async{
    final packet = CIMPacket.makePacket();
    packet.addInstance(patient);
    final response = await harness.agent.post(CIMRestApi.preparePatientsDelete(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
  });

  test('test delete doctor', ()async{
    final packet = CIMPacket.makePacket();
    packet.addInstance(doctor);
    final response = await harness.agent.post(CIMRestApi.prepareDoctorDelete(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
  });
  /*test("GET /example returns 200 {'key': 'value'}", () async {
    expectResponse(await harness.agent.get("/example"), 200, body: {"key": "value"});
  });*/
}
