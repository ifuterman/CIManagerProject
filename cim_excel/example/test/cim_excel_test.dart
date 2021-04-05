import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cim_excel/cim_excel.dart';

void main() {

  EquatableConfig.stringify = true;

  test('CIMExcel is Singletn!', () async {
    final cimExcel1 = CIMExcel;
    final cimExcel2 = CIMExcel;
    expect(cimExcel1, equals(cimExcel2));
    debugPrint('main.1: cimExcel1 = $cimExcel1');
    debugPrint('main.1: cimExcel2 = $cimExcel2');

    final res = await cimExcel1.open('path');
    expect(res.result, equals(ExcelResult.wrongFormat));
    debugPrint('main.2: cimExcel1 = $cimExcel1');
    debugPrint('main.2: cimExcel2 = $cimExcel2');
    expect(cimExcel1, equals(cimExcel2));
  });
}
