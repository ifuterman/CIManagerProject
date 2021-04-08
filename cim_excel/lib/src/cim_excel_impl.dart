import 'package:cim_excel/cim_excel.dart';
import 'package:vfx_flutter_common/utils.dart';

class CIMExcelImpl implements CIMExcelInterface {
  late String _path;

  @override
  String get path => _path;

  @override
  Future<Return<String, ExcelPage>> open(String path) async {
    _path = path;
    final result = Return<String, ExcelPage>(result: ExcelResult.wrongFormat);
    return result;
  }

  @override
  Future<Return<String, ExcelDataChunk>> retrieveRows({
    required int startRow,
    required int endRow,
    required int startColumn,
    required int endColumn,
  }) async {
    return Return<String, ExcelDataChunk>(result: ExcelResult.wrongFormat);
    ;
  }

  @override
  Future<Return<String, List<ExcelRow>>> touchRow(
      {required int index,
      required int startColumn,
      required int endColumn}) async {
    return Return<String, List<ExcelRow>>(result: ExcelResult.wrongFormat);
    ;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMExcelImpl &&
          runtimeType == other.runtimeType &&
          _path == other._path;

  @override
  int get hashCode => _path.hashCode;

  @override
  String toString() {
    return 'CIMExcelImpl{_path: $_path}';
  }
}
