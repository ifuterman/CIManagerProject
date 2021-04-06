import 'package:cim_client2/apps/excel/src/excel_view.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/data/provider/cache_provider.dart';
import 'package:cim_excel/cim_excel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

class ExcelViewController extends AppGetxService
    with SmartNavigationMixin<ExcelViewController> {

  late CacheProvider _cache;

  final data$ = Rx<ExcelPage>(ExcelPage.nil);

  @override
  get defaultGetPageBuilder => () => ExcelView();

  @override
  void onInit() {
    super.onInit();
    _cache = Get.find<CacheProvider>();
  }

  @override
  void onReady() {
    super.onReady();
    _cache.fetchExcelPage().then((value) {
      data$(value.data);
    });
    debugPrint('$now: ExcelViewController.onReady');
  }

}