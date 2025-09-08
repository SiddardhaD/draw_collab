import 'package:draw/app/model/draw_point.dart';
import 'package:draw/app/utils/constants.dart';
import 'package:draw/app/utils/styles.dart';
import 'package:draw/app/viewmodels/channel_lobby_view_model.dart';
import 'package:draw/app/viewmodels/draw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawingScreen extends ConsumerWidget {
  final String background;
  const DrawingScreen({super.key, required this.background});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(drawingPointsProvider);
    final channelID = ref.read(channelLobbyProvider.notifier).getChannelId();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(background!, fit: BoxFit.contain)),
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
                  .addPoint(
                    details.localPosition.dx,
                    details.localPosition.dy,
                    ref.watch(strokeWidthProvider.notifier).state,
                    channelID,
                    context,
                  );
            },
            onPanEnd: (_) {
              debugPrint("Length is ${points.length}");
              ref.read(drawingPointsProvider.notifier).addSeparator(channelID);
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
              ref
                  .read(drawingPointsProvider.notifier)
                  .deleteLastStroke(channelID);
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
              ref.read(drawingPointsProvider.notifier).clear(channelID);
            },
            tooltip: 'Clear All',
            child: Icon(Icons.delete),
          ),
          SizedBox(height: 10),

          // Change Pen Color
          FloatingActionButton(
            mini: true,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final strokeWidth = ref.watch(strokeWidthProvider);
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Stroke Width"),
                                Slider(
                                  min: 4,
                                  max: 100,
                                  divisions: 24,
                                  label: strokeWidth.round().toString(),
                                  value: strokeWidth,
                                  onChanged: (val) {
                                    ref
                                        .read(strokeWidthProvider.notifier)
                                        .state = val;
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
            tooltip: 'Stroke',
            child: Icon(Icons.edit),
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
    for (int i = 0; i < points.length - 1; i++) {
      final paint =
          Paint()
            ..color = Color(int.parse(AppColors.defaultColor, radix: 16))
            ..strokeWidth = points[i] == null ? 4.0 : points[i]!.stroke
            ..strokeCap = StrokeCap.round;
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          (points[i]!).toOffset(),
          points[i + 1]!.toOffset(),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
