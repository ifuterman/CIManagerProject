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

  var _startRow = 0;
  var _startCol = 0;

  @override
  get defaultGetPageBuilder => () => XcelView();

  void rowUp() {
    _startRow += 1;
    _update();
  }

  void rowDown() {
    _startRow = _startRow > 0 ? _startRow - 1 : _startRow;
    _update();
  }

  void colUp() {
    _startCol += 1;
    _update();
  }

  void colDown() {
    _startCol = _startCol > 0 ? _startCol - 1 : _startCol;
    _update();
  }

  @override
  void onReady() {
    super.onReady();
    _update();
    debugPrint('$now: ExcelViewController.onReady');
  }

  void _update() {
    _cache
        .fetchExcelPage(
      columnCount: 10,
      rowCount: 10,
      startRowIndex: _startRow,
      startColumnIndex: _startCol,
    )
        .then((value) {
      page$(value.data);
    });
  }
}
