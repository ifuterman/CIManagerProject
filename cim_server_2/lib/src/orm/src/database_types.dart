enum DatabaseTypes{
  /// Will be counted automatically
  auto,

  /// Represented by instances of [int].
  integer,

  /// Represented by instances of [int].
  bigInteger,

  /// Represented by instances of [String].
  text,

  /// Represented by instances of [DateTime].
  datetime,

  /// Represented by instances of [bool].
  boolean,

  /// Represented by instances of [double].
  doublePrecision,

  /// Represented by instances of [Map].
  map,

  /// Represented by instances of [List].
  list,

  /// Represented by instances of [Document]
  document
}