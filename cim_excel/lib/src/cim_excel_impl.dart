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

    // 1. opens external source with raw data:
    final rawData = _getRawData(path);
    if(rawData == null){
      _result = Return<String, ExcelPage>(result: ExcelResult.wrongFormat);
    }else{
      final data = ExcelPage(
        path: _path,
        title: 'Name of Excel List',
        width: 5,
        height: 6,
      );

      // captions trom raw to data
      final rawCaptions = rawData[0];
      for(var i = 0; i < rawCaptions.length; ++i){
        data.captions.data[i] = rawCaptions[i];
      }


      //
      _result = Return<String, ExcelPage>(result: ExcelResult.ok, data: data);
    }

    return _result;
  }

  @override
  Return<String, ExcelDataChunk> retrieveRows({int startRow, int endRow, int startColumn, int endColumn}) {
    return Return<String, ExcelDataChunk>(result: ExcelResult.wrongFormat);
  }

  @override
  Return<String, List<ExcelRow>> touchRow({int index, int startColumn, int endColumn}) {
    return Return<String, List<ExcelRow>>(result: ExcelResult.wrongFormat);;
  }

  ///
  List<List<dynamic>> _getRawData(String path) {
    // R6 * C5 matrix
    const maxColumnIndex = 4;
    const maxRowIndex = 5;
    final currentRow = <dynamic>[];
    final allData = <List<dynamic>>[];
    for(var r = 0; r < maxRowIndex; ++r){
      for(var c = 0; c < maxColumnIndex; ++c) {
        currentRow.add('row $r / col $c');
      }
      allData.add(List.from(currentRow));
      currentRow.clear();
    }

    return allData;
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
    return 'CIMExcelImpl{_path: $_path, _result: $_result}';
  }
}
