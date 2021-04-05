library cim_excel;
import 'package:equatable/equatable.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'src/cim_excel_impl.dart';

part 'src/cim_excel.dart';
part 'src/excel_entity.dart';
part 'src/excel_result.dart';

// ignore: non_constant_identifier_names
final CIMExcelInterface CIMExcel = CIMExcelImpl();
