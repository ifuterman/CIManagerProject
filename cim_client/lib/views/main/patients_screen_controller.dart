import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'patient_screen.dart';

class PatientsScreenController extends GetxController
    with SmartNavigationMixin<PatientsScreenController> {
  final updateScreen = RxBool(false);

  void needUpdate() => updateScreen.value = !updateScreen.value;
  final provider = CIMDataProvider();
  final patientItems = <PatientItem>[];

  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => PatientScreen();

  PatientsScreenController() {
    print('$now: PatientsScreenController.PatientsScreenController: $provider');
    for (CIMPatient p in provider.listPatients) {
      debugPrint(
          '$now: PatientsScreenController.PatientsScreenController: p = $p');
      patientItems.add(PatientItem(p));
    }
  }

  @override
  void onClose() {
    print('$now: PatientsScreenController.onClose');
    super.onClose();
  }
}



class PatientItem {
  final CIMPatient patient;

  PatientItem(this.patient);

  var isExpanded = false;

  final updated = RxBool(false);
}
