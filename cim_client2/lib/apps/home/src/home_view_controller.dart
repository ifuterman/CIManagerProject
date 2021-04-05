import 'dart:typed_data';

import 'package:cim_client2/apps/excel/src/excel_view_controller.dart';
import 'package:cim_client2/apps/home/src/home_view.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/services/connection_service.dart';
import 'package:cim_client2/core/services/global_service.dart';
import 'package:cim_client2/data/cim_errors.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'connect_view.dart';

const addresses = [
  '127.0.0.1',
  'google.com',
  'yandex.ru',
];

const ports = [
  '8888'
];


class HomeViewController extends AppGetxController
    with SmartNavigationMixin<HomeViewController> {
  final title$ = ''.obs;

  /// Just reference to [ConnectionService.connector$]
  late final Rx<Boolean<CIMErrors>> connectionResult$;

  late final ConnectionService _connectionService;

  final addressCtrl = TextEditingController();
  final portCtrl = TextEditingController();

  @override
  get defaultGetPageBuilder => () => HomeView();

  void changeTitle(String title) {
    Get.find<GlobalService>().changeTitle(title);
  }

  @override
  void onInit() {
    super.onInit();
    final gs = Get.find<GlobalService>();
    subscriptions.add(gs.title$.listen(title$));

    _connectionService = Get.find<ConnectionService>();
    connectionResult$ = _connectionService.connector$;
    subscriptions.add(_connectionService.connector$.listen(_processConnectResult));

    title$(gs.title$());
  }

  @override
  void onReady() {
    super.onReady();
    addressCtrl.text = addresses[0];
    portCtrl.text = ports[0];
    reconnect();
  }

  @override
  void onClose() {
    addressCtrl.dispose();
    portCtrl.dispose();
    super.onClose();
  }

  void reconnect() {
    _connectionService.connect();
  }

  Future excel() async{
    ByteData data = await rootBundle.load("assets/files/demo.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    debugPrint('$now: HomeViewController.excel: $excel');


    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      final sh = excel.tables[table];
      for(var i =0; i < 100; ++i){
        final row = sh?.row(i);
        print("$i =>  $row");
      }
      // print(excel.tables[table]?.maxCols);
      // print(excel.tables[table]?.maxRows);
      // for (var row in excel.tables[table]!.rows) {
      //   print("$row");
      // }
    }

    SmartNavigation.put(ExcelViewController()..toPage(
      onClose: (c, {args}){
        Get.back();
      }
    ));

  }

  void _processConnectResult(Boolean<CIMErrors> result) {
    // connectionResult$(result);
    if(!connectionResult$().isTrue){
      Get.defaultDialog(
        title: 'Ошибка коннекта',
        barrierDismissible: false,
        content: ConnectView()
      );
    }
  }
}

class ConnectionResult extends Equatable {
  const ConnectionResult({required this.result, required this.cimErrors});

  static const initial =
      ConnectionResult(result: false, cimErrors: CIMErrors.initial);

  final bool result;

  final CIMErrors cimErrors;

  @override
  List<Object?> get props => [result, cimErrors];
}
