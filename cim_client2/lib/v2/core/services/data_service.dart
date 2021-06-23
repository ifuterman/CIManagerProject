import 'package:cim_client2/v2/routing/routing.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:window_size/window_size.dart';

import 'data_stub.dart';

class DataService extends GetxServiceProxy{

  @override
  void onReady() {
    super.onReady();
  }

  Future<Boolean<List<CIMPatient>>> fetchPatients() async {
    await delayMilli(1000);
    return True(data: patientItemsStub);
  }
}