import 'package:cim_excel/cim_excel.dart';

class CIMExcelImpl implements CIMExcelInterface {
  
  String _path;

  ExcelResult _result;

  @override
  String get path => _path;

  @override
  ExcelResult get result => _result;

  @override
  ExcelResult open(String path) {
    _path = path;
    _result = ExcelResult.wrongFormat;
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