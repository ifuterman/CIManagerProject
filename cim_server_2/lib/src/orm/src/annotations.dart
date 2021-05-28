import 'package:cim_server_2/src/orm/src/database_types.dart';
enum ValueTypes{
  generated,
  notGenerated
}

class Table{
  final String name;
  const Table(this.name);
}

class Column{
  final ValueTypes valueType;
  final DatabaseTypes type;
  const Column({this.valueType = ValueTypes.notGenerated, this.type = DatabaseTypes.auto});
}