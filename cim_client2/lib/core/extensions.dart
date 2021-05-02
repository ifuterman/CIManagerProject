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
