
import 'dart:mirrors';

import 'package:cim_server_2/src/orm/annotations.dart';
import 'package:cim_server_2/src/orm/connection.dart';
import 'package:cim_server_2/src/orm/query.dart';
import 'package:test/test.dart';


class ManagedObject<T>{
  final T _instance = reflectClass(T).newInstance(Symbol.empty,List.empty()).reflectee;
  Symbol? key;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if(invocation.isGetter){
      key = invocation.memberName;
    }
    else{
      key = null;
    }
    var instanceMirror = reflect(_instance);
    var result = instanceMirror.delegate(invocation);
    return result;
  }
  ManagedObject();
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
class Predicate {
  dynamic value;
  Predicate(this.value);
}

class EqualPredicate extends Predicate{
  EqualPredicate(dynamic value):super(value);
}

class MorePredicate extends Predicate{

  MorePredicate(dynamic value):super(value);
}

class LessPredicate extends Predicate{
  LessPredicate(dynamic value):super(value);
}

class NotEqualPredicate extends Predicate{
  NotEqualPredicate(dynamic value):super(value);
}

enum ExpressionTypes{
  and,
  or
}
class Expression {
  ExpressionTypes get expressionType => ExpressionTypes.and;
  Symbol key;
  final predicates = List<Predicate>.empty(growable: true);
  Expression(this.key);
  Expression equalTo(dynamic value){
    predicates.add(EqualPredicate(value));
    return this;
  }
  Expression notEqual(dynamic value){
    predicates.add(NotEqualPredicate(value));
    return this;
  }
  Expression moreThen(dynamic value){
    predicates.add(MorePredicate(value));
    return this;
  }

  Expression lessThen(dynamic value){
    predicates.add(LessPredicate(value));
    return this;
  }
}

class OrExpression extends Expression{
  OrExpression(Symbol key): super(key);

  @override
  ExpressionTypes get expressionType => ExpressionTypes.or;
}

class Query<InstanceType extends ManagedObject>{
  List<Expression> whereClause = List.empty(growable: true);
  final Connection _connection;
  Query(this._connection);
  Expression where(
      dynamic Function(InstanceType type) propertyIdentifier){
    var key = traceKey(propertyIdentifier);
    var expression = Expression(key);
    whereClause.add(expression);
    return expression;
  }

  Expression orWhere(dynamic Function(InstanceType type) propertyIdentifier){
    var key = traceKey(propertyIdentifier);
    var expression = OrExpression(key);
    whereClause.add(expression);
    return expression;
  }

  Symbol traceKey(dynamic Function(InstanceType type) propertyIdentifier){
    var instanceMirror = reflectClass(InstanceType);
    var instance = instanceMirror.newInstance(Symbol.empty,List.empty()).reflectee;
    propertyIdentifier.call(instance);
    var key = (instance as ManagedObject).key;
    if(key == null){
      throw ArgumentError();
    }
    return key;
  }

}

void test_system(){

  var connection = Connection('host', 1, 'databaseName');
  var query = Query<TestTable>(connection).where((x) => x.id).equalTo(0);
}


void main (){
  group('server test', (){
    test('test config.yaml',(){
      test_system();
    });
  });
}