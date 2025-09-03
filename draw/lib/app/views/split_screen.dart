import 'package:draw/app/views/draw_screen.dart';
import 'package:draw/app/views/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitScreen extends ConsumerWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(112, 100, 105, 107),
              ),
            ),
            height: MediaQuery.of(context).size.height / 2,
            child: ViewScreen(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: DrawingScreen(),
          ),
        ],
      ),
    );
  }
}
