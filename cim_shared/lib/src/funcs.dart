part of cim_shared;

// Handy mini functions and properties
/// Delay in microseconds
Future delayMicro(int value) async =>
    Future<int>.delayed(Duration(microseconds: value));

/// Delay in milliseconds
Future<int> delayMilli(int value) async =>
    Future<int>.delayed(Duration(milliseconds: value));

/// Delay in seconds
Future delaySec(int value) async =>
    Future<int>.delayed(Duration(seconds: value));

/// Shortcut for [DateTime.now]
DateTime get now => DateTime.now();

