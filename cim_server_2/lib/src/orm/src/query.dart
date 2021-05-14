
import 'dart:mirrors';

import 'managed_object.dart';
import 'package:cim_server_2/src/orm/src/annotations.dart';
import 'package:cim_server_2/src/orm/src/connection.dart';
import 'package:postgres/postgres.dart';







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

class WrongMetadataStructure extends Error{}

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
  Future<List<InstanceType>> select() async{
    var table = getTableName();
    var query = 'SELECT * FROM $table';
    var result = await sendQuery(query);
    return parseResult(result);
  }

  String getTableName(){
    var classMirror = reflectClass(InstanceType);
    if(classMirror.superinterfaces.isEmpty){
      throw WrongMetadataStructure();
    }
    var interface = classMirror.superinterfaces[0];
    var tableName = interface.simpleName.toString();
    var metadata = interface.metadata;
    if(metadata.isNotEmpty){
      for(var mirror in metadata){
        if(mirror.type.simpleName == Symbol('Table')){
          var table = mirror.reflectee as Table;
          tableName = table.name;
        }
      }
    }
    return tableName;
  }

  Future<PostgreSQLResult> sendQuery(String query) async{

    if(_connection.isClosed) {
      await _connection.open();
    }
    var result = await _connection.query(query);
    print(result);
    return result;
  }

  List<InstanceType> parseResult(PostgreSQLResult result){
    var instances = List<InstanceType>.empty(growable: true);
    if (result.affectedRowCount == 0) {
      return instances;
    }
//    result.columnDescriptions[0].columnName
    for(var row in result){
      var mirror = reflectClass(InstanceType);
      var instance = mirror.newInstance(Symbol.empty, List.empty());
      if(mirror.superinterfaces.isEmpty){
        throw WrongMetadataStructure();
      }
      for(var i = 0; i < row.length; i++) {
        instance.setField(
            Symbol(row.columnDescriptions[i].columnName), row[i]);
      }
      instances.add(instance.reflectee);
    }
    return instances;
  }
}
