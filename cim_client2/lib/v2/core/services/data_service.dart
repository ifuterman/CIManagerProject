import 'package:cim_client2/v2/routing/routing.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:window_size/window_size.dart';

import 'data_stub.dart';

class DataService extends GetxServiceProxy{

  @override
  void onReady() {
    super.onReady();
  }

  Future<Boolean<List<CIMPatient>>> fetchPatients() async {
    await delayMilli(1000);
    return True(data: patientItemsStub);
  }

  /// Пример добавления пациента.
  /// Пока перехватывает только имя и фамилию,
  /// чтобы не строгать много на редакторе
  Future<Boolean<List<CIMPatient>>> addPatient(CIMPatient patient) async {
    final p = CIMPatient(
        patientItemsStub.length, patient.lastName, patient.name, Sex.male,
        status: Participation.free,
        snils: '222-333-444',
        phones: '+7(900)333-222-11',
        email: 'me@ya.ru',
        birthDate: DateTime(1965),
        middleName: 'Петрович'
    );
    patientItemsStub.add(p);
    return True(data: patientItemsStub);
  }


}