import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/service/draw_service.dart';
import 'package:draw/app/utils/constants.dart';
import 'package:flutter/widgets.dart';

class DrawingController {
  final DrawingService _service;

  DrawingController(this._service);

  void addPoint(
    double x,
    double y,
    double stroke,
    String channelID,
    BuildContext context,
  ) {
    final point = DrawPoint(
      x,
      y,
      Color(int.parse(AppColors.defaultColor, radix: 16)),
      stroke,
      timestamp: DateTime.now(),
    );
    _service.addPoint(point, channelID, context);
  }

  void addNull(String channelID) {
    _service.addNull(channelID);
  }

  List<DrawPoint> getPoints() {
    return _service.getPoints();
  }

  void clear(String channelID) {
    _service.clear(channelID);
  }
}
