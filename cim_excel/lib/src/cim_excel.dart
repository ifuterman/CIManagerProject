part of cim_excel;

/// Abstract class for Excel access
abstract class CIMExcelInterface {
  String get path;

  // Return<String, ExcelPage> get result;

  Future<Return<String, ExcelPage>> open(String path);

  Future<Return<String, List<ExcelRow>>> touchRow({
    required int index,
    required int startColumn,
    required int endColumn,
  });

  Future<Return<String, ExcelDataChunk>> retrieveRows({
    required int startRow,
    required int endRow,
    required int startColumn,
    required int endColumn,
  });
}
