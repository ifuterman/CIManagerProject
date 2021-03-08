part of cim_excel;

/// Abstract class for Excel access
abstract class CIMExcelInterface {
  
  String get path;
  ExcelResult get result;
  
  ExcelResult open(String path);

}