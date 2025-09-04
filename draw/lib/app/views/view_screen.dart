import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/utils/constants.dart';
import 'package:draw/app/utils/styles.dart';
import 'package:draw/app/viewmodels/draw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewScreen extends ConsumerWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPoints = ref.watch(drawingStreamProvider);

    return SafeArea(
      child: Scaffold(
        body: asyncPoints.when(
          data: (points) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(AppStrings.view, style: HeadingStyle.h1()),
                ),
                CustomPaint(
                  painter: ViewDrawingPainter(points),
                  size: Size.infinite,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("${AppStrings.error}: $e")),
        ),
      ),
    );
  }
}

class ViewDrawingPainter extends CustomPainter {
  final List<DrawPoint?> points;

  ViewDrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final paint =
          Paint()
            ..color = Colors.blue
            ..strokeWidth = points[i] == null ? 4.0 : points[i]!.stroke
            ..strokeCap = StrokeCap.round;
      if (points[i] != null && points[i + 1] != null) {
        final current = points[i];
        final next = points[i + 1];
        if (current!.x != 0.0 && next!.x != 0.0) {
          canvas.drawLine(current.toOffset(), next.toOffset(), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(ViewDrawingPainter oldDelegate) => true;
}
