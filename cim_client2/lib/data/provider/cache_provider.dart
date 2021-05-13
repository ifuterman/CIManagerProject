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
    int columnCount = 10,
    int rowCount = 10 + 1,
  });
}

class CacheProviderImpl extends GetConnect implements CacheProvider {
  @override
  Future<Boolean<ExcelPage>> fetchExcelPage({
    int startRowIndex = 0,
    int startColumnIndex = 0,
    int columnCount = 10,
    int rowCount = 11,
  }) async {
    ByteData data = await rootBundle.load("assets/files/demo.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    final page = ExcelPage(
        path: 'path',
        title: 'title',
        startColumnIndex: startColumnIndex,
        startRowIndex: startRowIndex,
        columnCount: columnCount,
        rowCount: rowCount);

    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table];
      for (var ri = 0; ri < rowCount; ++ri) {
        final List<Data?> fullRow = sheet!.row(ri+startRowIndex);
        if (ri > 0) {
          page.data.add(ExcelRow(length: columnCount, index: ri-1));
        }
        for (var ci = 0; ci < columnCount; ++ci) {
          final map = <int, dynamic>{};
          map[ci] = fullRow[ci+startColumnIndex]?.value;
          if (ri == 0) {
            page.captions.data[ci] = map[ci];
          } else {
            page.data[ri-1].data[ci] = map[ci];
          }
        }
      }
      break;
    }
    page.whole.assignAll([page.captions, ...page.data]);
    return True(data: page);
  }
}
