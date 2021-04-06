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
    ByteData data = await rootBundle.load("assets/files/demo.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    final page = ExcelPage(
        path: 'path',
        title: 'title',
        startColumnIndex: startColumnIndex,
        startRowIndex: startRowIndex,
        width: width,
        height: height);

    for (var table in excel.tables.keys) {
      debugPrint('$now: CacheProviderImpl.fetchExcelPage: $table');
      final sh = excel.tables[table];
      for (var i = startRowIndex; i < height; ++i) {
        final List<Data?> row = sh!.row(i);
        for (var k = 0; k < width; ++k) {
          final map = <int, dynamic>{};
          map[k] = row[k]?.value;
          if (i == 0) {
            page.captions.data.assignAll(map);
          } else {
            final er = ExcelRow(length: width, index: i);
            er.data.assignAll(map);
            page.data.add(er);
          }
        }
      }
      break;
    }
    debugPrint('$now: >> CacheProviderImpl.fetchExcelPage: $page');
    return True(data: page);
  }
}
