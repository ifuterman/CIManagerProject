T? fromArgs<T>(args, String key, {T? defValue}){
  if(args == null || args is! Map<String, dynamic>){
    return defValue;
  }
  if(!args.containsKey(key)){
    return defValue;
  }
  return args[key] as T;
}

T? fromMapEntry<T>(Map<String, dynamic> map, String key, {T? defValue}){
  if(!map.containsKey(key)){
    return defValue;
  }
  return map[key] as T;
}