import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'patients_screen.dart';

class PatientsScreenController extends GetxController
    with SmartNavigationMixin<PatientsScreenController> {


  PatientsScreenController(){
    print('$now: PatientsScreenController.PatientsScreenController: $provider');
    subWidgetPlacer$(PatientScreen());

    for (CIMPatient p in provider.listPatients) {
      debugPrint(
          '$now: PatientsScreenController.PatientsScreenController: p = $p');
      patientItems.add(PatientItem(p));
    }
  }

  final updateScreen = RxBool(false);

  final nameController = TextEditingController();

  void needUpdate() => updateScreen.value = !updateScreen.value;
  final provider = CIMDataProvider();
  final patientItems = <PatientItem>[
    PatientItem(
      CIMPatient(1, 'Куликов', 'Валерий', Sex.male,
          status: Participation.free,
          snils: '222-333-444',
          phones: '+7(900)333-222-11',
          email: 'me@ya.ru',
          birthDate: DateTime(1965),
          middleName: 'Петрович'),
    ),
    PatientItem(
      CIMPatient(2, 'Футерман', 'Иосиф', Sex.male,
          status: Participation.refuse,
          snils: '999-555-000',
          phones: '+7(910)111-333-77',
          email: 'futer@gmail.com',
          birthDate: DateTime(1980),
          middleName: 'Владимирович'),
    ),
    PatientItem(
      CIMPatient(3, 'Футерман', 'Елена', Sex.female,
          status: Participation.free,
          snils: '5656-1313-888',
          phones: '+7(904)656-06-90',
          email: 'she@ya.ru',
          birthDate: DateTime(1982),
          middleName: 'Ивановна'),
    ),
  ];

  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => PatientScreenMain();

  @override
  void onClose() {
    print('$now: PatientsScreenController.onClose');
    nameController.dispose();
    super.onClose();
  }


  void addNew() {
    subWidgetPlacer$(AddNew());
  }


  // void addNew2() {
  //   subWidgetPlacer$(AddNew2());
  //   // subWidgetPlacer$(PatientScreen());
  // }

  void confirmAdding() {
    subWidgetPlacer$(PatientScreen());
  }
}

class PatientItem {
  final CIMPatient patient;

  PatientItem(this.patient);

  var isExpanded = false;

  final updated = RxBool(false);
}
