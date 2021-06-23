import 'package:flutter/material.dart';

extension NumberExtensions on num {
  SizedBox h() {
    return SizedBox(
      height: double.parse(toString()),
    );
  }

  SizedBox w() {
    return SizedBox(
      width: double.parse(toString()),
    );
  }
}

extension StringLengthExtensions on String {
  String maxLen(int max) {
    assert(max > -1);
    return length < max ? this : substring(0, max);
  }
}
