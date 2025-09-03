import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/service/draw_service.dart';

class DrawingController {
  final DrawingService _service;

  DrawingController(this._service);

  void addPoint(double x, double y) {
    final point = DrawPoint(x, y, timestamp: DateTime.now());
    _service.addPoint(point);
  }

  void addNull() {
    _service.addNull();
  }

  List<DrawPoint> getPoints() {
    return _service.getPoints();
  }

  void clear() {
    _service.clear();
  }
}
