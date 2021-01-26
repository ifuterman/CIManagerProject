//import 'package:ci_manager/cim_patient.dart';
import 'package:cim_protocol/cim_protocol.dart';

class CIMDataProvider{
  List<CIMPatient> listPatients;
  CIMDataProvider(){
    MockData mockData = MockData();
    listPatients = mockData.patientsList;
  }
}

class MockData{
  List<CIMPatient> patientsList = List();
  MockData(){

    patientsList.add(CIMPatient( "Петрова", "Надежда", "Ивановна", DateTime(1982, 2, 19), Sex.female, Participation.unknown));
    patientsList.add(CIMPatient( "Петров", "Петр", "Петрович", DateTime(1985, 1, 9), Sex.male, Participation.free));
  }
}