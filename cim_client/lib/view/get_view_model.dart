import 'package:cim_client/CIMDataProvider.dart';
import 'package:cim_client/CIMPatient.dart';
import 'package:get/get.dart';

class AuthorisationViewModel{
  String user = "";
}

class ConnectionViewModel{
  String address = "";
  RxBool connected = RxBool(false);
  bool isConnected()=> connected.value;
  bool checkConnection(){
    //TODO:Implement connection check
    connected.value = true;
  }
}

class PatientsScreenModel{
  RxBool updateScreen = RxBool(false);
  void needUpdate() => updateScreen.value = !updateScreen.value;
  final CIMDataProvider provider = CIMDataProvider();
  List<PatientItem> patientItems = List();
  PatientsScreenModel(){
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