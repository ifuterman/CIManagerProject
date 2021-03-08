part of cim_excel;

///
abstract class ExcelResult extends Equatable{
  static const String ok = 'excel_file_ok';
  static const String fileNotRead = 'excel_file_not_read';
  static const String wrongFormat = 'wrong_format';
}