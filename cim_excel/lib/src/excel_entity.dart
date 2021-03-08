part of cim_excel;

/// 
class ExcelPage extends Equatable {
  ExcelPage({this.path, this.title});

  final String path;
  final String title;

  @override
  List<Object> get props => [title];
}

