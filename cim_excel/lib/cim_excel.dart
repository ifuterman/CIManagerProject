library cim_excel;

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'src/cim_excel_impl.dart';

part 'src/cim_excel.dart';
part 'src/excel_entity.dart';
part 'src/excel_result.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  final hive = Hive.box('name');

}

// ignore: non_constant_identifier_names
final CIMExcelInterface CIMExcel = CIMExcelImpl();
