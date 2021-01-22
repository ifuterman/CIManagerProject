import 'package:cim_client/CIMDataProvider.dart';
import 'package:cim_client/CIMPatient.dart';
import 'package:get/get.dart';

enum ConnectionStates{
  checking,
  connected,
  disconnected,
  unknown
}

class AuthorisationViewModel{
  String user = "";
}

class ConnectionViewModel{
  ConnectionStates _connectionState = ConnectionStates.unknown;

  ConnectionStates get connectionState => _connectionState;

  set connectionState(ConnectionStates value) {
    _connectionState = value;
    updateScreen();
  }

  String address;
  int port;
  RxBool updateScreenTrigger = RxBool(false);
  void updateScreen() => updateScreenTrigger.value = !updateScreenTrigger.value;
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