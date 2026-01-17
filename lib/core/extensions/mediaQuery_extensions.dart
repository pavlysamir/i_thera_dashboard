import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  double get hightMediaQuery {
    return MediaQuery.of(this).size.height;
  }

  double get widthMediaQuery {
    return MediaQuery.of(this).size.width;
  }
}
