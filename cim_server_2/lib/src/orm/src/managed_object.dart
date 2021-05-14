import 'dart:mirrors';

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