import 'package:flutter/material.dart';

extension NumExtension on num {
  num get toOpposite {
    if (isNegative) {
      return abs();
    } else {
      return "-$this".toInt;
    }
  }
}

extension StringExtension on String? {
  int get toInt {
    return int.tryParse(this ?? "") ?? 0;
  }
}


extension ScrollControllerExtension on ScrollController {
  double get max => position.maxScrollExtent;
  double get min => position.minScrollExtent;
}
