part of cim_excel;

/// Abstract class for Excel access
abstract class CIMExcelInterface {
  String get path;

  Return<String, ExcelPage> get result;

  Return<String, ExcelPage> open(String path);

  Return<String, List<ExcelRow>> touchRow({
    int index,
    int startColumn,
    int endColumn,
  });

  Return<String, ExcelDataChunk> retrieveRows({
    int startRow,
    int endRow,
    int startColumn,
    int endColumn,
  });
}
