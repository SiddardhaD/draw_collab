import 'package:flutter/material.dart';

class DrawPoint {
  final double x;
  final double y;
  final DateTime timestamp;

  // Constructor
  DrawPoint(this.x, this.y, {DateTime? timestamp})
    : this.timestamp = timestamp ?? DateTime.now();

  Offset toOffset() => Offset(x, y);

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y, 'timestamp': timestamp.toIso8601String()};
  }

  factory DrawPoint.fromJson(Map<String, dynamic> json) {
    return DrawPoint(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now(),
    );
  }
}
