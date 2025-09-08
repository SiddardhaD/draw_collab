import 'package:draw/app/views/draw_screen.dart';
import 'package:draw/app/views/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitScreen extends ConsumerWidget {
  final String background;
  const SplitScreen({super.key, required this.background});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(),
            height: MediaQuery.of(context).size.height / 2,
            child: ViewScreen(background: background),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: DrawingScreen(background: background),
          ),
        ],
      ),
    );
  }
}
