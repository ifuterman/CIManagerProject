import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/shared/smart_nav.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart' hide Trans;

import 'patient_screen.dart';

class PatientsScreenController extends GetxController with SmartNavigationMixin<PatientsScreenController> {
  final updateScreen = RxBool(false);

  void needUpdate() => updateScreen.value = !updateScreen.value;
  final provider = CIMDataProvider();
  final patientItems = <PatientItem>[];

  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => PatientScreen();


  PatientsScreenController() {
    print('$now: PatientsScreenController.PatientsScreenController');
    for (CIMPatient p in provider.listPatients)
      patientItems.add(PatientItem(p));
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
