part of cim_excel;

///
class ExcelPage extends Equatable {
  ExcelPage({
    required this.path,
    required this.title,
    this.startRowIndex = 0,
    this.startColumnIndex = 0,
    this.columnCount = 10,
    this.rowCount = 11,
  }) : captions = ExcelRow(length: columnCount, index: startRowIndex);

  static final empty = ExcelPage(path: '', title: '', columnCount: 0, rowCount: 0);

  /// File path
  final String path;

  /// File title
  final String title;

  /// First row index in sample
  final int startRowIndex;

  /// First column index in sample
  final int startColumnIndex;

  /// Sample width (in columns)
  final int columnCount;

  /// Sample height (in rows)
  final int rowCount;

  /// Captions (first row in sample)
  final ExcelRow captions;

  /// Other rows in sample
  final data = <ExcelRow>[];

  final whole = <ExcelRow>[];

  @override
  List<Object> get props => [
        path,
        title,
        'start_row: $startRowIndex',
        'start_col: $startColumnIndex',
        'width: $columnCount',
        'height: $rowCount',
        'captions: $captions',
        'data: $data'
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
  List<Object> get props => ['length: $length', 'index: $index', 'data: $data'];
}

///
class ExcelDataChunk extends Equatable {
  final valid = <ExcelRow>[];
  final invalid = <ExcelRow>[];

  @override
  List<Object> get props => ['valid: $valid', 'invalid: $invalid'];
}