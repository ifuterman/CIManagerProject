part of cim_excel;

///
class ExcelResult extends Equatable{
  static const ExcelResult ok = ExcelResult._('ok');
  static const ExcelResult fileNotRead = ExcelResult._('fileNotRead');
  static const ExcelResult wrongFormat = ExcelResult._('wrongFormat');

  const ExcelResult._(this.result);
  final String result;

  @override
  List<Object> get props => [result];
}