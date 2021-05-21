import 'dart:mirrors';

abstract class Predicate {
  dynamic value;
  Predicate(this.value);
  String buildQuery(){
    var val = value.toString();
    if(value is String){
      val = '\'$val\'';
    }
    var res = '${getSign()} $val';
    return res;
  }
  String getSign();
}

class EqualPredicate extends Predicate{
  EqualPredicate(dynamic value):super(value);
  @override
  String getSign() => '=';
}

class MorePredicate extends Predicate{
  MorePredicate(dynamic value):super(value);
  @override
  String getSign() => '>';
}

class MoreEqualPredicate extends Predicate{
  MoreEqualPredicate(dynamic value):super(value);
  @override
  String getSign() => '>=';
}

class LessPredicate extends Predicate{
  LessPredicate(dynamic value):super(value);
  @override
  String getSign() => '<';
}

class LessEqualPredicate extends Predicate{
  LessEqualPredicate(dynamic value):super(value);
  @override
  String getSign() => '<=';
}

class NotEqualPredicate extends Predicate{
  NotEqualPredicate(dynamic value):super(value);
  @override
  String getSign() => '!=';
}

enum ExpressionTypes{
  first,
  and,
  or
}
class Expression {
  final ExpressionTypes _expressionType;
  Expression(this.key, {ExpressionTypes expressionType = ExpressionTypes.and}):_expressionType = expressionType;
  String buildQuery(){
    if(predicates.isEmpty){
      return '';
    }
    var strKey = MirrorSystem.getName(key);
    var res = '';
    res += '$strKey ${predicates[0].buildQuery()}';
    if(predicates.length < 2){
      return res;
    }
    final operator = _expressionType.toString().toUpperCase();
    for(var i = 1; i < predicates.length; i ++){
      res += ' $operator $strKey ' + predicates[i].buildQuery();
    }
    return res;
  }
  Symbol key;
  final predicates = List<Predicate>.empty(growable: true);
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