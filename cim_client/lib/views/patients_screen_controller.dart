import 'package:cim_client/cim_data_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';





class PatientsScreenController extends GetxController{
  RxBool updateScreen = RxBool(false);
  void needUpdate() => updateScreen.value = !updateScreen.value;
  final CIMDataProvider provider = CIMDataProvider();
  List<PatientItem> patientItems = List();
  PatientsScreenController(){
    for(CIMPatient p in provider.listPatients)
      patientItems.add(PatientItem(p));
  }

}

class PatientItem{

  final CIMPatient patient;
  PatientItem(this.patient);
  bool isExpanded = false;

  RxBool updated = RxBool(false);
}