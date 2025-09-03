import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw/app/controller/draw_controller.dart';
import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/service/draw_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawingServiceProvider = Provider<DrawingService>((ref) {
  return DrawingService();
});

final drawingControllerProvider = Provider<DrawingController>((ref) {
  return DrawingController(ref.read(drawingServiceProvider));
});

final drawingPointsProvider =
    StateNotifierProvider<DrawingViewModel, List<DrawPoint?>>((ref) {
      return DrawingViewModel(ref.read(drawingControllerProvider));
    });

class DrawingViewModel extends StateNotifier<List<DrawPoint?>> {
  final DrawingController _controller;

  DrawingViewModel(this._controller) : super([]);

  void addPoint(double x, double y) {
    final point = DrawPoint(x, y);
    _controller.addPoint(x, y);
    state = [...state, point];
  }

  void addSeparator() {
    state = [...state, null, null];
    _controller.addNull();
    debugPrint("last  = ${state.last}");
  }

  void undo() {
    final lastNullIndex = state.lastIndexWhere((p) => p == null);
    state = lastNullIndex == -1 ? [] : state.sublist(0, lastNullIndex + 1);
  }

  // void changePenColor(Color color) {
  //   _penColor = color; // store a color in ViewModel
  // }

  void clear() {
    _controller.clear();
    state = [];
  }
}

/// 16033
final drawingStreamProvider = StreamProvider<List<DrawPoint>>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore
      .collection('drawings')
      .doc('2')
      .collection('points')
      .orderBy('t')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return DrawPoint(
            data["x"]?.toDouble() ?? 0.0,
            data["y"]?.toDouble() ?? 0.0,
          );
        }).toList();
      });
});
