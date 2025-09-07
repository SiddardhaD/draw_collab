import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw/app/controller/draw_controller.dart';
import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/service/draw_service.dart';
import 'package:draw/app/utils/constants.dart';
import 'package:draw/app/viewmodels/channel_lobby_view_model.dart';
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
final strokeWidthProvider = StateProvider<double>((ref) => 4.0);

class DrawingViewModel extends StateNotifier<List<DrawPoint?>> {
  final DrawingController _controller;
  double _strokeWidth = 4.0;

  DrawingViewModel(this._controller) : super([]);

  double get strokeWidth => _strokeWidth;
  void addPoint(double x, double y, double stroke, String channelID) {
    final point = DrawPoint(
      x,
      y,
      Color(int.parse(AppColors.defaultColor, radix: 16)),
      stroke,
    );
    _controller.addPoint(x, y, stroke, channelID);
    state = [...state, point];
  }

  void addSeparator(String channelID) {
    state = [...state, null, null];
    _controller.addNull(channelID);
    debugPrint("last  = ${state.last}");
  }

  void undo() {
    final strokes = <List<DrawPoint?>>[];
    var currentStroke = <DrawPoint?>[];

    for (int i = 0; i < state.length; i++) {
      if (i < state.length - 1 && state[i] == null && state[i + 1] == null) {
        if (currentStroke.isNotEmpty) {
          strokes.add(List.from(currentStroke));
          currentStroke.clear();
        }
        i++;
      } else {
        currentStroke.add(state[i]);
      }
    }

    if (currentStroke.isNotEmpty) {
      strokes.add(currentStroke);
    }
    if (strokes.isNotEmpty) {
      strokes.removeLast();
    }

    final newState = <DrawPoint?>[];
    for (var stroke in strokes) {
      newState.addAll(stroke);
      newState.addAll([null, null]);
    }

    state = newState;
  }

  Future<void> deleteLastStroke(channelID) async {
    final firestore = FirebaseFirestore.instance;
    final pointsRef = firestore
        .collection('drawings')
        .doc(channelID)
        .collection('points');

    final snapshot = await pointsRef.orderBy('t').get();
    final docs = snapshot.docs;
    if (docs.isEmpty) return;

    final sepIndexes = <int>[];
    for (int i = 0; i < docs.length; i++) {
      final data = docs[i].data();
      if (!data.containsKey('x') && !data.containsKey('y')) {
        sepIndexes.add(i);
      }
    }

    if (sepIndexes.length < 2) return;
    final start = sepIndexes[sepIndexes.length - 2];
    final end = sepIndexes.last;

    if (start > end) return;
    final batch = firestore.batch();
    for (int i = start; i < end; i++) {
      batch.delete(docs[i].reference);
    }
    await batch.commit();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
  }

  // void changePenColor(Color color) {
  //   _penColor = color; // store a color in ViewModel
  // }

  void clear(String channelID) {
    _controller.clear(channelID);
    state = [];
  }
}

/// 16033
final drawingStreamProvider = StreamProvider<List<DrawPoint>>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final chanelId = ref.read(channelLobbyProvider.notifier).getChannelId();
  return firestore
      .collection('drawings')
      .doc(chanelId)
      .collection('points')
      .orderBy('t')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return DrawPoint(
            data["x"]?.toDouble() ?? 0.0,
            data["y"]?.toDouble() ?? 0.0,
            data["p"] ?? Color(int.parse(AppColors.defaultColor, radix: 16)),
            data["s"] ?? 4.0,
            timestamp: DateTime.parse(data["t"]),
          );
        }).toList();
      });
});
final firebaseConnection = StreamProvider.family<List<DrawPoint>, String>((
  ref,
  channelID,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore
      .collection('drawings')
      .doc(channelID)
      .collection('points')
      .orderBy('t')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return DrawPoint(
            data["x"]?.toDouble() ?? 0.0,
            data["y"]?.toDouble() ?? 0.0,
            data["p"] ?? Color(int.parse(AppColors.defaultColor, radix: 16)),
            data["s"] ?? 4.0,
            timestamp: DateTime.parse(data["t"]),
          );
        }).toList();
      });
});
