///
bool hasNoSense<T>(T value, {T matcher}) {
  if(null == value) {
    return true;
  }
  if(value is String && (matcher == null || matcher is String)){
    return value == (matcher ?? '');
  }
  if(value is int && (matcher == null || matcher is int)){
    return value == (matcher ?? 0);
  }
  return true;
}

///
bool hasSense<T>(T value, {T matcher}) {
  if(null == value) {
    return false;
  }
  if(value is String && (matcher == null || matcher is String)){
    return value == (matcher ?? '');
  }
  if(value is int && (matcher == null || matcher is int)){
    return value == (matcher ?? 0);
  }
  return false;
}
