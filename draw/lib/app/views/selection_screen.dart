import 'package:draw/app/views/split_screen.dart';
import 'package:flutter/material.dart';

class SketchSelectionScreen extends StatelessWidget {
  final List<String> sketches = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
    'assets/images/7.jpg',
  ];

  SketchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose a Sketch".toUpperCase(),
          style: TextStyle(fontSize: 14, letterSpacing: 8),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: sketches.length,
          itemBuilder: (context, index) {
            final sketch = sketches[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SplitScreen(background: sketch),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(sketch, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
