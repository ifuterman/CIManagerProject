import 'package:cim_excel/cim_excel.dart';
import 'package:cim_shared/cim_shared.dart';

class CIMExcelImpl implements CIMExcelInterface {
  
  String _path;

  Return<String, ExcelPage> _result;

  @override
  String get path => _path;

  @override
  Return<String, ExcelPage> get result => _result;

  @override
  Return<String, ExcelPage> open(String path) {
    _path = path;
    _result = Return<String, ExcelPage>(result: ExcelResult.wrongFormat);
    return _result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMExcelImpl &&
          runtimeType == other.runtimeType &&
          _path == other._path &&
          _result == other._result;

  @override
  int get hashCode => _path.hashCode ^ _result.hashCode;

  @override
  String toString() {
    return 'path = $path. result = $result';
  }
}