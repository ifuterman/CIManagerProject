import 'package:cim_client2/apps/excel/src/excel_view.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';

class ExcelViewController extends AppGetxService
    with SmartNavigationMixin<ExcelViewController> {

  @override
  get defaultGetPageBuilder => () => ExcelView();

}