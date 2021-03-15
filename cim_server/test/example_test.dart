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




  test('test delete doctor', ()async{
    var packet = CIMPacket.makePacket();
    packet.addInstance(doctor);
    final response = await harness.agent.post(CIMRestApi.prepareDoctorDelete(),headers: authorisation, body: packet.map);
    expectResponse(response, 200);
  });
  /*test("GET /example returns 200 {'key': 'value'}", () async {
    expectResponse(await harness.agent.get("/example"), 200, body: {"key": "value"});
  });*/
}
