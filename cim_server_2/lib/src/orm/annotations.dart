import 'package:cim_server_2/src/orm/database_types.dart';

class Table{
  final String name;
  const Table(this.name);
}

class Column{
  final DatabaseTypes type;
  const Column({this.type = DatabaseTypes.auto});
}