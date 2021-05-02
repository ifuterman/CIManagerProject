import 'dart:typed_data';

import 'package:cim_excel/cim_excel.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/utils.dart';

// ignore: one_member_abstracts
abstract class CacheProvider {
  Future<Boolean<ExcelPage>> fetchExcelPage({
    int startRowIndex = 0,
    int startColumnIndex = 0,
    int width = 10,
    int height = 10 + 1,
  });
}

class CacheProviderImpl extends GetConnect implements CacheProvider {
  @override
  Future<Boolean<ExcelPage>> fetchExcelPage({
    int startRowIndex = 0,
    int startColumnIndex = 0,
    int width = 10,
    int height = 10 + 1,
  }) async {
    ByteData data = await rootBundle.load("assets/files/demo2.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    final page = ExcelPage(
        path: 'path',
        title: 'title',
        startColumnIndex: startColumnIndex,
        startRowIndex: startRowIndex,
        width: width,
        height: height);

    debugPrint('$now: CacheProviderImpl.fetchExcelPage.0: w = $width, h = $height, '
        'startRow = $startRowIndex, startCol = $startColumnIndex');
    for (var table in excel.tables.keys) {
      debugPrint('$now: CacheProviderImpl.fetchExcelPage.1: $table');
      final sheet = excel.tables[table];
      for (var ri = 0; ri < height; ++ri) {
        // sheet!.row(ri) returns all the data from Library!
        final List<Data?> fullRow = sheet!.row(ri+startRowIndex);
        // debugPrint('$now: CacheProviderImpl.fetchExcelPage.2: fullRow = $fullRow\n---------');
        if (ri > 0) {
          page.data.add(ExcelRow(length: width, index: ri-1));
        }
        for (var ci = 0; ci < width; ++ci) {
          final map = <int, dynamic>{};
          map[ci] = fullRow[ci+startColumnIndex]?.value;
          debugPrint('$now: CacheProviderImpl.fetchExcelPage: RC[$ri:$ci] = ${map[ci]}');
          if (ri == 0) {
            page.captions.data[ci] = map[ci];
            debugPrint('$now: CacheProviderImpl.fetchExcelPage: page.captions = ${page.captions}');
          } else {
            // final er = ExcelRow(length: width, index: ri);
            // er.data.assignAll(map);
            debugPrint('$now: CacheProviderImpl.fetchExcelPage: ri-1 = ${ri-1}, ci = $ci');
            page.data[ri-1].data[ci] = map[ci];
            debugPrint('$now: CacheProviderImpl.fetchExcelPage: page.data = ${page.data}');
          }
        }
      }
      break;
    }
    debugPrint('$now: >> CacheProviderImpl.fetchExcelPage: page = $page');
    page.whole.assignAll([page.captions, ...page.data]);
    debugPrint('$now: >> CacheProviderImpl.fetchExcelPage: whole = ${page.whole}');
    return True(data: page);
  }
}
