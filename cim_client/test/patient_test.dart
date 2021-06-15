
import 'package:cim_client/model/entity/patient.dart';
import 'package:cim_client/model/entity/user.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vfx_flutter_common/utils.dart';

void main (){
  test('Patient test', () async {
    final pat = Patient(
      id: 10,
      name: 'name',
      middleName: 'middleName',
      lastName: 'lastName',
      birthDate: DateTime(1994),
      phone: 'phone',
      email: 'email',
      snils: 'snils',
      status: Participation.blocked,
      sex: Sex.female,
    );
    expect(pat, equals(Patient(
      id: 10,
      name: 'name',
      middleName: 'middleName',
      lastName: 'lastName',
      birthDate: DateTime(1994),
      phone: 'phone',
      email: 'email',
      snils: 'snils',
      status: Participation.blocked,
      sex: Sex.female,
    )));
    final pat2 = pat.copyWith(status: Participation.free);
    expect(pat2,isNot(pat));
  });

  test('Patients test', () async {
    final pats = Patients(IList());
    expect(pats.items.length, equals(0));
    final pats2 = pats.copyWith(
        items: pats.items
            .add(Patient(
          id: 10,
          name: 'name',
          middleName: 'middleName',
          lastName: 'lastName',
          birthDate: DateTime(1994),
          phone: 'phone',
          email: 'email',
          snils: 'snils',
          status: Participation.blocked,
          sex: Sex.female,
        )));
    expect(pats2.items.length, equals(1));
  });
}