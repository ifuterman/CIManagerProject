import 'package:cim_client2/v2/core/services/data_service.dart';
import 'package:cim_client2/v2/model/model_state.dart';
import 'package:cim_client2/v2/shared/app_page_controller.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:get/get.dart';

import 'patients_view.dart';

typedef PatientItems = List<PatientItem>;

class PatientsViewController extends AppPageController
    with SmartNavigationMixin<PatientsViewController> {

  PatientsViewController({DataService? dataService})
      : _dataService = dataService ?? Get.find();

  final patientItems$ = Rx<ModelState<PatientItems>>(Initial());

  @override
  SubWidgetBuilder get defaultSubWidgetBuilder => () => PatientsView();

  final DataService _dataService;

  Stream<ModelState<PatientItems>> fetchData() async* {
    yield Loading();
    final res = await _dataService.fetchPatients();
    if(!res.isTrue) {
      yield ErrorDetails(res.description);
      return;
    }
    yield Data(res.data!.map((e) => PatientItem(e)).toList());
  }

  @override
  void onInit() {
    super.onInit();
    subscriptions.add(fetchData().listen((event) => patientItems$(event)));
  }

  @override
  void onClose() {
    debugPrint('$now: PatientsViewController.onClose');
    super.onClose();
  }

  void addNew() {
  }
}

class DataState<T> {


}

class PatientItem {
  final CIMPatient patient;

  PatientItem(this.patient);

  var isExpanded = false;

  final updated$ = false.obs;
}
