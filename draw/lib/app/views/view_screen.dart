import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/utils/constants.dart';
import 'package:draw/app/utils/styles.dart';
import 'package:draw/app/viewmodels/draw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewScreen extends ConsumerWidget {
  final String background;
  const ViewScreen({super.key, required this.background});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPoints = ref.watch(drawingStreamProvider);

    return SafeArea(
      bottom: false,
      child: asyncPoints.when(
        data: (points) {
          return Stack(
            children: [
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.065,
                right: 0,
                left: 0,
                bottom: 0,
                child: Image.asset(background, fit: BoxFit.cover),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(AppStrings.view, style: HeadingStyle.h1()),
              ),
              CustomPaint(
                painter: ViewDrawingPainter(points, context),
                size: Size.infinite,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${AppStrings.error}: $e")),
      ),
    );
  }
}

class ViewDrawingPainter extends CustomPainter {
  final List<DrawPoint?> points;
  final BuildContext context;

  ViewDrawingPainter(this.points, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final size = MediaQuery.of(context).size;
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
          canvas.drawLine(
            (DrawPoint(
              current.x * size.width,
              current.y * size.height,
              current.penColor,
              current.stroke,
              timestamp: current.timestamp,
            )).toOffset(),
            (DrawPoint(
              next.x * size.width,
              next.y * size.height,
              next.penColor,
              next.stroke,
              timestamp: next.timestamp,
            )).toOffset(),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ViewDrawingPainter oldDelegate) => true;
}
