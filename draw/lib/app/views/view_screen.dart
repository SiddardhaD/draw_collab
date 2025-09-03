import 'package:draw/app/utils/styles.dart';
import 'package:draw/app/viewmodels/draw_view_model.dart';
import 'package:draw/app/views/draw_screen.dart';
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
                  child: Text("VIEW", style: HeadingStyle.h1()),
                ),
                CustomPaint(
                  painter: DrawingPainter(points),
                  size: Size.infinite,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
