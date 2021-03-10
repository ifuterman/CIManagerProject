part of cim_excel;

///
class ExcelPage extends Equatable {
  ExcelPage({
    this.path,
    this.title,
    this.width = 10,
    this.height = 10+1,
  }) : captions = ExcelRow(width);

  final String path;
  final String title;
  final int width;
  final int height;
  final ExcelRow captions;
  final data = <ExcelRow>[];

  @override
  List<Object> get props => [path, title, width, height, captions, data];
}

class ExcelRow {
  ExcelRow(this.length);

  final int length;
  final data = <int, dynamic>{};
}
