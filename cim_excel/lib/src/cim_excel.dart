part of cim_excel;

/// Abstract class for Excel access
abstract class CIMExcelInterface {
  String get path;

  Return<String, ExcelPage> get result;

  Return<String, ExcelPage> open(String path);

  Return<String, ExcelRow> retrieveRow(int index);

}
