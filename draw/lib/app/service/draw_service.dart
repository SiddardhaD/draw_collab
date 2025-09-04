import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw/app/model/draw_point.dart';

class DrawingService {
  final List<DrawPoint> _points = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addPoint(DrawPoint point) {
    _points.add(point);
    _firestore.collection('drawings').doc("2").collection('points').add({
      "x": point.x,
      "y": point.y,
      "t": point.timestamp.toIso8601String(),
      's': point.stroke,
    });
  }

  void addNull() {
    _firestore.collection('drawings').doc("2").collection('points').add({
      "t": DateTime.now().toIso8601String(),
    });
  }

  List<DrawPoint> getPoints() {
    return List.unmodifiable(_points);
  }

  void clear() {
    _points.clear();
    _firestore.collection('drawings').doc("2").collection('points').get().then((
      snapshot,
    ) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
