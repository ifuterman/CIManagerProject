import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:cim_client/views/temp_start/temp_start.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

class TempStartViewController extends AppGetxController
    with SmartNavigationMixin<TempStartViewController> {

  @override
  // TODO: implement defaultGetPageBuilder
  get defaultGetPageBuilder => ()=>TempStartView();

}