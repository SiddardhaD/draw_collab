import 'package:flutter/material.dart';

extension HeadingStyle on TextStyle {
  static TextStyle h1({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 12,
    );
  }
}
