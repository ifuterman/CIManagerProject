
import 'dart:mirrors';

import 'expression.dart';
import 'managed_object.dart';
import 'package:cim_server_2/src/orm/src/annotations.dart';
import 'package:cim_server_2/src/orm/src/connection.dart';
import 'package:postgres/postgres.dart';
import 'exceptions.dart';

class Query<InstanceType extends ManagedObject>{
  late InstanceType values;
  List<Expression> whereClause = List.empty(growable: true);
  Connection _connection;
  Query(this._connection){
    var instanceMirror = reflectClass(InstanceType);
    values = instanceMirror.newInstance(Symbol.empty,List.empty()).reflectee;
  }
  Expression where(
      dynamic Function(InstanceType type) propertyIdentifier){
    var key = traceKey(propertyIdentifier);
    var expression;
    if(whereClause.isEmpty){
      expression = Expression(key, expressionType: ExpressionTypes.first);
    }
    else{
      expression = Expression(key);
    }
    whereClause.add(expression);
    return expression;
  }

  Expression orWhere(dynamic Function(InstanceType type) propertyIdentifier){
    var key = traceKey(propertyIdentifier);
    var expression = Expression(key, expressionType: ExpressionTypes.or);
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
    if(whereClause.isNotEmpty){
      query += ' WHERE ';
      for(var i = 0; i < whereClause.length; i++) {
        query += whereClause[i].buildQuery();
      }
    }
//    var result = await sendQuery(query);
    checkConnection();
    var result = await _connection.query(query);
    return parseResult(result);
  }

  Future<int> delete() async{
    var table = getTableName();
    var query = 'DELETE FROM $table';
    if(whereClause.isNotEmpty){
      query += ' WHERE ';
      for(var i = 0; i < whereClause.length; i++) {
        query += whereClause[i].buildQuery();
      }
    }
    checkConnection();
    var result = await _connection.execute(query);
    return result;
  }

  Future<int> insert() async{
    var table = getTableName();
    var query = 'INSERT INTO $table';
    var classMirror = reflectClass(InstanceType);
    var columns = List<Symbol>.empty(growable: true);
    if(classMirror.superinterfaces.isEmpty){
      throw WrongMetadataStructure();
    }
    classMirror = classMirror.superinterfaces[0];
    if(classMirror is! ManagedObject){
      throw WrongMetadataStructure();
    }
    for(var key in classMirror.declarations.keys){
      var declaration = classMirror.declarations[key];
      if(declaration is! VariableMirror){
        continue;
      }
      columns.add(key);
    }
    if(columns.isNotEmpty){
      var strValues = List<String>.empty(growable: true);
      var instanceMirror = reflect(values);
      query += '(';
      for(var i = 0; i < columns.length; i++){
        var value = instanceMirror.getField(columns[i]);
        query += ' ${MirrorSystem.getName(columns[i])},';
        if(value.reflectee == null){
          strValues.add('NULL');
          continue;
        }
        strValues.add(value.toString());
      }
      var index = query.lastIndexOf(',');
      query = query.replaceRange(index, query.length, ')');
      query += 'VALUES(';
      for(var i = 0; i < strValues.length; i++){
        query += ' ${strValues[i]},';
      }
      query = query.replaceRange(index, query.length, ')');
    }
    var result = await _connection.execute(query);
    return result;
  }

  void checkConnection() async{
    if(!_connection.isClosed){
      return;
    }
    //_connection = Connection(host, port, databaseName)
    _connection = Connection(_connection.host, _connection.port, _connection.databaseName,
        username: _connection.username, password: _connection.password, timeoutInSeconds: _connection.timeoutInSeconds,
    queryTimeoutInSeconds: _connection.queryTimeoutInSeconds, isUnixSocket: _connection.isUnixSocket,
      timeZone: _connection.timeZone, useSSL: _connection.useSSL);
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

  /*Future<PostgreSQLResult> sendQuery(String query) async{
    var result = await _connection.query(query);
    return result;
  }*/

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
