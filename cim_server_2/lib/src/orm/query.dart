import 'dart:mirrors';

import 'package:cim_server_2/src/orm/annotations.dart';
import 'package:cim_server_2/src/orm/connection.dart';


class ManagedObject<T>{
  final T _instance = reflectClass(T).newInstance(Symbol.empty,List.empty()).reflectee;
  bool trace = false;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if(trace){
      print('trace key');
    }
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
  late String value;
  Expression equalTo(T value){
    return this;
  }
}
class Query<InstanceType extends ManagedObject>{
  List<Expression> whereClause = List.empty(growable: true);
  final Connection _connection;
  Query(this._connection);
  void where(
      dynamic Function(InstanceType type) propertyIdentifier){
    var instanceMirror = reflectClass(InstanceType);
    var instance = instanceMirror.newInstance(Symbol.empty,List.empty()).reflectee;
//    (instance as ManagedObject).trace = true;
    propertyIdentifier.call(instance);
    var funcMirror = reflect(propertyIdentifier);
//    var expression = Expression<T, InstanceType>(propertyIdentifier);
//    whereClause.add(expression);
//    return expression;
  }
}

void Test(){

  var connection = Connection('host', 1, 'databaseName');
  var query = Query<TestTable>(connection).where((x) => x.id);
}
