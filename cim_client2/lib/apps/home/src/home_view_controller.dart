import 'package:cim_client2/apps/home/src/home_view.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/services/connection_service.dart';
import 'package:cim_client2/core/services/global_service.dart';
import 'package:cim_client2/data/cim_errors.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

class HomeViewController extends AppGetxController with SmartNavigationMixin<HomeViewController>{

  final title$ = ''.obs;

  late ConnectionService _connectionService;

  final connectionResult$ = ConnectionResult.initial.obs;

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
    subscriptions.add(_connectionService.connector$.listen(_connect));

    title$(gs.title$());
  }

  @override
  void onReady() {
    super.onReady();
    _connectionService.connect();

  }

  void _connect(CIMErrors result){
    connectionResult$(ConnectionResult(result: true, cimErrors: result));
  }

}

class ConnectionResult extends Equatable {
  const ConnectionResult({required this.result, required this.cimErrors});

  static const initial = ConnectionResult(
      result: false, cimErrors: CIMErrors.initial);

  final bool result;

  final CIMErrors cimErrors;

  @override
  List<Object?> get props => [result, cimErrors];
}