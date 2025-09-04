import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/utils/constants.dart';
import 'package:draw/app/utils/styles.dart';
import 'package:draw/app/viewmodels/draw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawingScreen extends ConsumerWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(drawingPointsProvider);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(AppStrings.draw, style: HeadingStyle.h1()),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              ref
                  .read(drawingPointsProvider.notifier)
                  .addPoint(details.localPosition.dx, details.localPosition.dy);
            },
            onPanEnd: (_) {
              debugPrint("Length is ${points.length}");
              ref.read(drawingPointsProvider.notifier).addSeparator();
            },
            child: CustomPaint(
              painter: DrawingPainter(points),
              size: Size.infinite,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Undo Button
          FloatingActionButton(
            heroTag: 'undo',
            mini: true,
            onPressed: () {
              ref.read(drawingPointsProvider.notifier).undo();
              ref.read(drawingPointsProvider.notifier).deleteLastStroke();
            },
            tooltip: 'Undo',
            child: Icon(Icons.undo),
          ),
          SizedBox(height: 10),

          // Delete All Button
          FloatingActionButton(
            heroTag: 'delete_all',
            mini: true,
            onPressed: () {
              ref.read(drawingPointsProvider.notifier).clear();
            },
            tooltip: 'Clear All',
            child: Icon(Icons.delete),
          ),
          SizedBox(height: 10),

          // Change Pen Color
          FloatingActionButton(
            heroTag: 'pen_color',
            mini: true,
            onPressed: () {
              // ref
              //     .read(drawingPointsProvider.notifier)
              //     .changePenColor(Colors.red);
            },

            tooltip: 'Change Pen Color',
            child: Icon(Icons.color_lens),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawPoint?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.toOffset(),
          points[i + 1]!.toOffset(),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
