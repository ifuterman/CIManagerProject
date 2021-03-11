import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cim_excel/cim_excel.dart';

void main() {

  EquatableConfig.stringify = true;

  test('CIMExcel is Singleton!', () {
    final cimExcel1 = CIMExcel;
    final cimExcel2 = CIMExcel;
    expect(cimExcel1, equals(cimExcel2));
    debugPrint('main.1: cimExcel1 = $cimExcel1');
    debugPrint('main.1: cimExcel2 = $cimExcel2');

    final res = cimExcel1.open('wrong_path');
    expect(res.result, equals(ExcelResult.wrongFormat));
    debugPrint('main.2: cimExcel1 = $cimExcel1');
    debugPrint('main.2: cimExcel2 = $cimExcel2');
    expect(cimExcel1, equals(cimExcel2));
  });

  test('Touching a rows', () {
    final cimExcel = CIMExcel;
    final res = cimExcel.open('wrong_path');
    expect(res.result, equals(ExcelResult.wrongFormat));
    final res2 = cimExcel.touchRow(index: 1, startColumn: 1, endColumn: 5);
    expect(res2.result, equals(ExcelResult.wrongFormat));
    final res3 = cimExcel.retrieveRows(startRow: 1, endRow: 10, startColumn: 1, endColumn: 5);
    expect(res3.result, equals(ExcelResult.wrongFormat));
  });
}
