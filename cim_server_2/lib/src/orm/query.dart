import 'dart:mirrors';

import 'package:cim_server_2/src/orm/annotations.dart';
import 'package:cim_server_2/src/orm/connection.dart';

void Test(){

  var connection = Connection('host', 1, 'databaseName');
  var query = Query<TestTable>(connection).where(expression);
}

class ManagedObject<T>{
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  ManagedObject();
  static ManagedObject makeInstance(){
    throw UnimplementedError();
  }
}

class TestTable extends ManagedObject<_TestTable> implements _TestTable{

}

@Table('testTable')
class _TestTable{
  @Column()
  int? id;
  @Column()
  String? text;
}
class Predicate <T>{

}

class Expression <T>{
  Expression(Predicate Function(T type) function);
}
class Query<T extends ManagedData>{
  T value = T();
  final Connection _connection;
  Query(this._connection);
  Query where(Expression expression){
    return this;
 }
}