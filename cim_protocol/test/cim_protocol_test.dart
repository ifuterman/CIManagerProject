import 'package:cim_protocol/src/mappers/cim_json_mapper.dart';
import 'package:test/test.dart';

import 'package:cim_protocol/cim_protocol.dart';

void main() {
  group('tests for CIMJsonMapper_0_0_1', () {
    CIMUser user = CIMUser.fromJson(0, 'test_login', 'test_password', UserRoles.administrator);

    setUp(() {
    });
    test('test userToMap and userFromMap', () {
      var map = <String, String>{};
      var mapper = CIMJsonMapper.getMapper();
      expect(mapper, isNotNull);
      mapper.userToMap(user, map);
      var user2 = mapper.userFromMap(map);
      expect(user2, isNotNull);
      expect(user, equals(user2));
    });
    test('test to CIMPacket from CIMPacket', () {
      var packet = CIMPacket.makePacket();
      expect(packet, isNotNull);
      packet.addInstance(user);
      var map = packet.map;
      packet = CIMPacket.makePacketFromMap(map);
      var list = packet.getInstances();
      var user2 = list[0];
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
