import 'package:cim_client2/core/services/data_service.dart';
import 'package:cim_client2/model/model_state.dart';
import 'package:cim_client2/shared/app_page_controller.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:get/get.dart';

import 'patients_view.dart';

typedef PatientItems = List<PatientItem>;

class PatientsViewController extends AppPageController
    with SmartNavigationMixin<PatientsViewController> {

  PatientsViewController({DataService? dataService})
      : _dataService = dataService ?? Get.find(){
    debugPrint('$now: PatientsViewController.PatientsViewController: ');
    // subWidgetPlacer$(PatientsView());
    // subWidgetPlacer$(PatientsView());
  }

  final patientItems$ = Rx<ModelState<PatientItems>>(Initial());

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final middleController = TextEditingController();

  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => PatientsView();

  final DataService _dataService;

  Stream<ModelState<PatientItems>> fetchData() async* {
    debugPrint('$now: PatientsViewController.fetchData: ');
    yield Loading();
    final res = await _dataService.fetchPatients();
    if(!res.isTrue) {
      yield ErrorDetails(res.description);
      return;
    }
    yield Data(res.data!.map((e) => PatientItem(e)).toList());
    debugPrint('$now: >> PatientsViewController.fetchData: ');
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('$now: PatientsViewController.onInit: ');
    subscriptions.add(fetchData().listen((event) {
      debugPrint('$now: PatientsViewController.onInit: fetchData().listen($event)');
      patientItems$(event);
    }));
  }

  @override
  void onReady() {
    super.onReady();
    subWidgetPlacer$(PatientsView());
  }

  @override
  void onClose() {
    debugPrint('$now: PatientsViewController.onClose');
    nameController.dispose();
    surnameController.dispose();
    middleController.dispose();
    super.onClose();
  }

  void addNew() {
    subWidgetPlacer$(AddNew());
  }

  Future confirmAdding() async {
    subWidgetPlacer$(PatientsView());
    final p = CIMPatient(
      0,
      surnameController.text,
      nameController.text,
      Sex.male,
    );
    final res = await _dataService.addPatient(p);
    final data = Data(res.data!.map((e) => PatientItem(e)).toList());
    patientItems$(data);
  }
}

class PatientItem {
  final CIMPatient patient;

  PatientItem(this.patient);

  var isExpanded = false;

  final updated$ = false.obs;
}
