import 'package:cim_protocol/cim_protocol.dart';
import 'package:equatable/equatable.dart';

class CIMDataProvider extends Equatable{

  final listPatients = <CIMPatient>[];

  CIMDataProvider() {
    listPatients.addAll(MockData().patientsList);
  }

  @override
  List<Object> get props => [listPatients];
}

class MockData {
  List<CIMPatient> patientsList = List.empty(growable: true);

  MockData() {
    /*patientsList.add(CIMPatient("Петрова", "Надежда", "Ивановна",
        DateTime(1982, 2, 19), Sex.female, Participation.unknown));
    patientsList.add(CIMPatient("Петров", "Петр", "Петрович",
        DateTime(1985, 1, 9), Sex.male, Participation.free));*/
  }
}
