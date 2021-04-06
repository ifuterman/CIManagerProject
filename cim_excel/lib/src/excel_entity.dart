part of cim_excel;

///
class ExcelPage extends Equatable {
  ExcelPage({
    required this.path,
    required this.title,
    this.startRowIndex = 0,
    this.startColumnIndex = 0,
    this.width = 10,
    this.height = 10 + 1,
  }) : captions = ExcelRow(length: width, index: startRowIndex);

  static final nil = ExcelPage(path: '', title: '');

  /// File path
  final String path;

  /// File title
  final String title;

  /// First row index in sample
  final int startRowIndex;

  /// First column index in sample
  final int startColumnIndex;

  /// Sample width (in columns)
  final int width;

  /// Sample height (in rows)
  final int height;

  /// Captions (first row in sample)
  final ExcelRow captions;

  /// Other rows in sample
  final data = <ExcelRow>[];

  @override
  List<Object> get props => [
        path,
        title,
        startRowIndex,
        startColumnIndex,
        width,
        height,
        captions,
        data
      ];
}

///
class ExcelRow extends Equatable {
  ExcelRow({required this.length, required this.index});

  /// row index in Excel
  final int index;

  /// row length (in columns)
  final int length;
  final data = <int, dynamic>{};

  @override
  List<Object> get props => [length, data];
}

///
class ExcelDataChunk extends Equatable {
  final valid = <ExcelRow>[];
  final invalid = <ExcelRow>[];

  @override
  List<Object> get props => [valid, invalid];
}