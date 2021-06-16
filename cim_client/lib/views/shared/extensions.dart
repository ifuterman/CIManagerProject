import 'package:flutter/material.dart';

extension NumberExtensions on num {
  /// Add horizontal space
  Widget get h => SizedBox(height: double.parse(toString()));

  /// Add horizontal space
  SizedBox get w => SizedBox(width: double.parse(toString()));
}
