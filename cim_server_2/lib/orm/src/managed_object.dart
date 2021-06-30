import 'dart:mirrors';

class ManagedObject<T>{
  final T _instance = reflectClass(T).newInstance(Symbol.empty,List.empty()).reflectee;
  Set<Symbol> settersList = {};
  Symbol? key;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    key = null;
    if(invocation.isGetter){
      key = invocation.memberName;
    }
    else if (invocation.isSetter){
      var str = MirrorSystem.getName(invocation.memberName);
      settersList.add(Symbol(str.replaceAll('=', '')));
    }
    var instanceMirror = reflect(_instance);
    var result = instanceMirror.delegate(invocation);
    return result;
  }
  ManagedObject();
}