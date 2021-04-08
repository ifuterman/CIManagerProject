import 'package:test/test.dart';
//import '../lib/cim_protocol.dart';
import 'package:cim_protocol/cim_protocol.dart';

enum testEnum{e1, e2}
void main() {
  group('tests for CIMJsonMapper_0_0_1', () {
    var user = CIMUser.fromJson(0,
        'test_login',
        'test_password',
        UserRoles.administrator);
    var patient = CIMPatient(1, 'Petrov', 'Ivan', Sex.male,
        phones: '+79122534202',
        email: 'xxx@gmail.com',
        birthDate: DateTime.utc(1979),
        middleName: 'petrov',
        snils: 'xxxxx', status: Participation.free);
    var doctor = CIMDoctor('Ivan', 'Ivanov', DoctorSpeciality.therapist,
        middleName: 'Ivanovich',
        birthDate: DateTime.utc(1980),
        email: 'yyy@fgmed.ru',
        phones: '+79122534222',
        userId: 0,
        id: 1);
    var schedule = CIMSchedule(1, patient, DateTime.now(),
        note: 'schedule note',
        doctor: doctor,
        duration: 45);
    setUp(() {
    });
    test('test userToMap and userFromMap', () {
      var map = <String, dynamic>{};
      var mapper = CIMJsonMapper.getMapper();
      expect(mapper, isNotNull);
      mapper!.userToMap(user, map);
      var user2 = mapper.userFromMap(map);
      expect(user2, isNotNull);
      expect(user, equals(user2));
    });
    test('test doctorToMap and doctorFromMap', (){
      var map = <String, dynamic>{};
      var mapper = CIMJsonMapper.getMapper();
      expect(mapper, isNotNull);
      mapper!.doctorToMap(doctor, map);
      var doctor2 = mapper.doctorFromMap(map);
      expect(doctor2, isNotNull);
      expect(doctor, equals(doctor2));
    });
    test('test patientToMap and patientFromMap', (){
      var map = <String, dynamic>{};
      var mapper = CIMJsonMapper.getMapper();
      expect(mapper, isNotNull);
      mapper!.patientToMap(patient, map);
      var patient2 = mapper.patientFromMap(map);
      expect(patient2, isNotNull);
      expect(patient, equals(patient2));
    });
    test('test sceduleToMap and scheduleFromMap',() {
      var map = <String, dynamic>{};
      var mapper = CIMJsonMapper.getMapper();
      expect(mapper, isNotNull);
      mapper!.scheduleToMap(schedule, map);
      var schedule2 = mapper.scheduleFromMap(map);
      expect(schedule2, isNotNull);
      expect(schedule, equals(schedule2));
    });
    test('test to CIMPacket from CIMPacket', () {
      var packet = CIMPacket.makePacket();
      expect(packet, isNotNull);
      packet!.addInstance(user);
      packet.addInstance(doctor);
      packet.addInstance(patient);
      packet.addInstance(schedule);
      var map = packet.map;
      packet = CIMPacket.makePacketFromMap(map);
      var list = packet!.getInstances();
      var user2;
      var doctor2;
      var patient2;
      var schedule2;
      for(var instance in list!){
        if(instance is CIMUser){
          user2 = instance;
          continue;
        }
        if(instance is CIMPatient){
          patient2 = instance;
          continue;
        }
        if(instance is CIMDoctor){
          doctor2 = instance;
          continue;
        }
        if(instance is CIMSchedule){
          schedule2 = instance;
          continue;
        }
        expect(user2, isNotNull);
        expect(user, equals(user2));
        expect(doctor2, isNotNull);
        expect(doctor, equals(doctor2));
        expect(patient2, isNotNull);
        expect(patient, equals(patient2));
        expect(schedule2, isNotNull);
        expect(schedule, equals(schedule2));
      }
      expect(user, equals(user2));
    });

    /*
    test('test toMap and fromMap', () {
      var mapper = CIMJsonMapper.getMapper();
      var map = mapper.toMap(user);
      expect(mapper, isNotNull);
      var user2 = CIMJsonMapper.fromMap(map);
      expect(user2, isNotNull);
      expect(user2 is CIMUser, true);
      expect(user, equals(user2));
    });*/
  });
}
