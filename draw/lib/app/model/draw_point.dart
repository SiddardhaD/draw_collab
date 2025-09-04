import 'package:draw/app/utils/constants.dart';
import 'package:flutter/material.dart';

class DrawPoint {
  final double x;
  final double y;
  final DateTime timestamp;
  final Color penColor;
  final double stroke;

  // Constructor
  DrawPoint(this.x, this.y, this.penColor, this.stroke, {DateTime? timestamp})
    : this.timestamp = timestamp ?? DateTime.now();

  Offset toOffset() => Offset(x, y);

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y, 'timestamp': timestamp.toIso8601String()};
  }

  factory DrawPoint.fromJson(Map<String, dynamic> json) {
    return DrawPoint(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      Color(int.parse(AppColors.defaultColor, radix: 16)),
      json['stroke'],
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now(),
    );
  }
}
