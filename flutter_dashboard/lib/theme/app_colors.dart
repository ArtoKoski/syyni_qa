import 'package:flutter/material.dart';

class AppColors {
  static Color background(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color card(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  static Color text(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }
}
