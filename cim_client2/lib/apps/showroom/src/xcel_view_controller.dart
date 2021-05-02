import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/data/provider/cache_provider.dart';
import 'package:cim_excel/cim_excel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'home_view.dart';
import 'show_room_view_controller.dart';
import 'xcel_view.dart';

class XcelViewController extends AppGetxController
    with SmartNavigationMixin<XcelViewController> {

  XcelViewController({CacheProvider? cacheProvider})
      : this._cache = cacheProvider ?? Get.find<CacheProvider>();

  final CacheProvider _cache;

  final page$ = ExcelPage.empty.obs;

  final state = State.excel;

  @override
  get defaultGetPageBuilder => () => XcelView();

  @override
  void onReady() {
    super.onReady();
    _cache.fetchExcelPage(width: 3, height: 2).then((value) {
      page$(value.data);
    });
    debugPrint('$now: ExcelViewController.onReady');
  }

}
