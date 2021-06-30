
import 'dart:mirrors';
import 'package:intl/intl.dart';
import 'expression.dart';
import 'managed_object.dart';
import 'annotations.dart';
import 'connection.dart';
import 'package:postgres/postgres.dart';
import 'exceptions.dart';
/*
* Класс Query описывает SQL запрос для POSTGRESQL и позволяет генерировать его в ORM стиле.
* пример работы:
* 1. Нужно создать класс-представление структуры таблицы, в этом классе аннотациями
* @Table('users') - аннотация, указывающая имя таблицы в БД
class _CIMUserDB{
  @Column(valueType: ValueTypes.generated) - аннотация, указывающая,
  * что поле id соответсвует столбцу id в таблице users в БД.
  * valueType: ValueTypes.generated - указывает, что это значение генерирует БД
  int? id;
  @Column()
  String? username;
  @Column()
  String? pwrd;
  @Column()
  String? role;
}
* 2. Класс для работы системы типизации. Все дополнительные функции реализуются именно в нём
* class CIMUserDB extends ManagedObject<_CIMUserDB> implements _CIMUserDB{
  CIMUser toUser(){
    final user = CIMUser(username!, pwrd!);
    try {
      user.role =
          UserRoles.values.firstWhere((element) => element.toString() == role);
    }catch(e){user.role = UserRoles.patient;}
      user.id = id!;
      return user;
    }
  }
* 3. Создается соединение с БД
*var dbConnection = Connection(database_host, database_port,
        database_name, username: 'username', password: 'password');
*await dbConnection.open();
* *********************************************************************
* 4. Выполнение запроса SELECT
* var query = Query<CIMUserDB>(connection)
      ..where((x) => x.username).equalTo(user.login);
  var userDBlist = await query.select();
* Результатом выполнения будет List<CIMUserDB>. Выборка выполняется на основе
* условий в where.
* 5. Выполнение запроса DELETE
* var query = Query<CIMUserDB>(connection)
      ..where((x) => x.username).equalTo(user.login);
  var userDBlist = await query.delete();
* 6. Выполнение запроса INSERT
* query = Query<CIMUserDB>(connection)
        ..values.username = user.login
        ..values.pwrd = user.password
        ..values.role = user.role.toString();
      var result = await query.insert();
* Результатом выполнения будет List<CIMUserDB> с данными фактически отражающими заначение полей,
* т.е. если есть поля с автогенерацией значений, они не указываются в конструкции ..values,
* но фактические значения будут содержаться в результате запроса
* */

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

  Future<InstanceType?> selectOne() async{
    var result = await select();
    if(result.length != 1){
      return null;
    }
    return result[0];
  }

  Future<List<InstanceType>> select() async{
    var table = getTableName();
    var query = 'SELECT * FROM $table';
    if(whereClause.isNotEmpty){
      query += ' WHERE ${whereClause[0].buildQuery()}';
      for(var i = 1; i < whereClause.length; i++) {
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

  Future<InstanceType?> insertOne() async {
    var result = await insert();
    if(result.length != 1){
      return null;
    }
    return result[0];
  }

  Future<List<InstanceType>> insert() async{
    var table = getTableName();
    var query = 'INSERT INTO $table';
    var classMirror = reflectClass(InstanceType);
    var columns = List<Symbol>.empty(growable: true);
    if(classMirror.superinterfaces.isEmpty){
      throw WrongMetadataStructure();
    }
    classMirror = classMirror.superinterfaces[0];
/*    if(classMirror is! ManagedObject){
      throw WrongMetadataStructure();
    }*/
    for(var key in classMirror.declarations.keys){
      ManagedObject m = values;
      if(!m.settersList.contains(key)){
        continue;
      }
      var declaration = classMirror.declarations[key];
      if(declaration is! VariableMirror){
        continue;
      }
      if(declaration.metadata.isEmpty){
        continue;
      }
      var metadata = declaration.metadata[0];
      if(!metadata.hasReflectee || metadata.reflectee is! Column){
        continue;
      }
      var columnAnnotation = metadata.reflectee as Column;
      if(columnAnnotation.valueType == ValueTypes.generated){
        continue;
      }
      columns.add(key);
    }
    if(columns.isNotEmpty){
      var strValues = List<String>.empty(growable: true);
      var instanceMirror = reflect(values);
      query += ' (';
      for(var i = 0; i < columns.length; i++){
        var value = instanceMirror.getField(columns[i]);
        query += ' ${MirrorSystem.getName(columns[i])},';
        if(value.reflectee == null){
          strValues.add('NULL');
          continue;
        }
        if(value.reflectee is String){
          strValues.add('\'${value.reflectee}\'');
        }
        else if(value.type.isEnum){
          strValues.add('\'${value.reflectee.toString()}\'');
        }
        else if (value.reflectee is DateTime){
          var datetime = value.reflectee as DateTime;
          var format = DateFormat('yyyy-MM-dd H:mm:ss');
          var str = format.format(datetime);
          strValues.add('\'$str\'');
        }
        else {
          strValues.add(value.reflectee.toString());
        }
      }
      var index = query.lastIndexOf(',');
      query = query.replaceRange(index, query.length, ')');
      query += ' VALUES ( ';
      for(var i = 0; i < strValues.length; i++){
        query += ' ${strValues[i]},';
      }
      index = query.lastIndexOf(',');
      query = query.replaceRange(index, query.length, ')');
    }
    query += ' RETURNING *';
    var result = await _connection.query(query);
    var instances = parseResult(result);
    return instances;
//    var instances = parseResult(result);
 //   var result = await _connection.execute(query);
//    return instances.length;
  }

  Future<InstanceType?> updateOne() async {
    var table = getTableName();
    var query = 'UPDATE $table SET ';
    var classMirror = reflectClass(InstanceType);
    var columns = List<Symbol>.empty(growable: true);
    if(classMirror.superinterfaces.isEmpty){
      throw WrongMetadataStructure();
    }
    classMirror = classMirror.superinterfaces[0];
/*    if(classMirror is! ManagedObject){
      throw WrongMetadataStructure();
    }*/
    for(var key in classMirror.declarations.keys){
      ManagedObject m = values;
      if(!m.settersList.contains(key)){
        continue;
      }
      var declaration = classMirror.declarations[key];
      if(declaration is! VariableMirror){
        continue;
      }
      if(declaration.metadata.isEmpty){
        continue;
      }
      var metadata = declaration.metadata[0];
      if(!metadata.hasReflectee || metadata.reflectee is! Column){
        continue;
      }
      var columnAnnotation = metadata.reflectee as Column;
      if(columnAnnotation.valueType == ValueTypes.generated){
        continue;
      }
      columns.add(key);
    }
    if(columns.isNotEmpty){
      var instanceMirror = reflect(values);
      for(var i = 0; i < columns.length; i++){
        var value = instanceMirror.getField(columns[i]);
        query += ' ${MirrorSystem.getName(columns[i])} = ';
        if(value.reflectee == null){
          query += 'NULL,';
          continue;
        }
        String strVal;
        if(value.reflectee is String){
          strVal = '\'${value.reflectee}\',';
        }
        else if(value.type.isEnum){
          strVal = '\'${value.reflectee.toString()}\',';
        }
        else if (value.reflectee is DateTime){
          var datetime = value.reflectee as DateTime;
          var format = DateFormat('yyyy-MM-dd H:mm:ss');
          var str = format.format(datetime);
          strVal = '\'$str\',';
        }
        else {
          strVal = '\'${value.reflectee.toString()}\',';
        }
        query += strVal;
      }
      var index = query.lastIndexOf(',');
      query = query.replaceRange(index, query.length, '');
      if(whereClause.isNotEmpty) {

        query += ' WHERE ${whereClause[0].buildQuery()}';
        for(var i = 1; i < whereClause.length; i++) {
          query += whereClause[i].buildQuery();
        }
      }
    }
    query += ' RETURNING *';
    var result = await _connection.query(query);
    var instances = parseResult(result);
    if(instances.isEmpty){
      return null;
    }
    return instances[0];
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
        var column = Symbol(row.columnDescriptions[i].columnName);
        var fieldMirror = instance.getField(column);
        dynamic value = row[i];
        if(fieldMirror.type.isEnum && value is String){
          var classMirror = fieldMirror.type;
          var reflection = classMirror.getField(#values).reflectee as List;
          /*
          * Код потенциально воняет. Происходит смена типа value со стринга на enum
          * */
          value = reflection.firstWhere((element) => element.toString() ==
                value);///////
        }
        instance.setField(column, value);
      }
      instances.add(instance.reflectee);
    }
    return instances;
  }
}
