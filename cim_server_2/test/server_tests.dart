
import 'dart:convert';
import 'dart:mirrors';

import 'package:cim_server_2/src/orm/annotations.dart';
import 'package:cim_server_2/src/orm/connection.dart';
import 'package:test/test.dart';

class ManagedObject<T>{
  final T _instance = reflectClass(T).newInstance(Symbol.empty,List.empty()).reflectee;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    var instanceMirror = reflect(_instance);
    var result = instanceMirror.delegate(invocation);
    return result;
  }
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

class Expression <T, InstanceType>{
  Expression(InstanceType);
}
class Query<InstanceType extends ManagedObject>{
  List<Expression> whereClause = List.empty(growable: true);
  final Connection _connection;
  Query(this._connection);
  Expression<T, InstanceType> where<T>(
      T Function(InstanceType type) propertyIdentifier){
    var closure = reflect(propertyIdentifier);
    if(closure is! ClosureMirror){
      throw ArgumentError;
    }
    var function = closure.function;
    var param = function.parameters.first;
    var expression = Expression<T, InstanceType>(param);
    whereClause.add(expression);
    return expression;
  }
}

void test_system(){

  var connection = Connection('host', 1, 'databaseName');
  var query = Query<TestTable>(connection).where((x) => x.id);
}


void main (){
  group('server test', (){
    test('test config.yaml',(){
      test_system();
    });
  });
}