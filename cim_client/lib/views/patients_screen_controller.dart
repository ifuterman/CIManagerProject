import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart' hide Trans;

class PatientsScreenController extends GetxController {
  final updateScreen = RxBool(false);

  void needUpdate() => updateScreen.value = !updateScreen.value;
  final provider = CIMDataProvider();
  final patientItems = <PatientItem>[];

  PatientsScreenController() {
    for (CIMPatient p in provider.listPatients)
      patientItems.add(PatientItem(p));
  }
}

class PatientItem {
  final CIMPatient patient;

  PatientItem(this.patient);

  var isExpanded = false;

  final updated = RxBool(false);
}
