import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final int rows = 3;
  final int cols = 3;
  List<Rect> piecePositions = [];
  List<int> shuffledIndices = [];
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final imageData =
        await DefaultAssetBundle.of(context).load("assets/images/logo.jpg");
    final codec =
        await ui.instantiateImageCodec(imageData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      image = frame.image;
      _initializePuzzle();
    });
  }

  void _initializePuzzle() {
    piecePositions = List.generate(rows * cols, (index) {
      int row = index ~/ cols;
      int col = index % cols;
      return Rect.fromLTWH(
        col * (image!.width / cols),
        row * (image!.height / rows),
        image!.width / cols,
        image!.height / rows,
      );
    });
    shuffledIndices = List.generate(rows * cols, (index) => index)
      ..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Jigsaw Puzzle")),
      body: Center(
        child: SizedBox(
          width: 600,
          height: 600,
          child: Stack(
            children: List.generate(rows * cols, (index) {
              int originalIndex = shuffledIndices[index];
              Rect rect = piecePositions[originalIndex];
              return Positioned(
                left: (index % cols) * 100,
                top: (index ~/ cols) * 100,
                child: Draggable<int>(
                  data: originalIndex,
                  feedback: CustomPaint(
                    size: Size(rect.width, rect.height),
                    painter: PuzzlePiecePainter(image!, rect),
                  ),
                  childWhenDragging: Container(),
                  child: DragTarget<int>(
                    onAccept: (receivedIndex) {
                      setState(() {
                        int temp = shuffledIndices[index];
                        shuffledIndices[index] = shuffledIndices[receivedIndex];
                        shuffledIndices[receivedIndex] = temp;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return CustomPaint(
                        size: Size(rect.width, rect.height),
                        painter: PuzzlePiecePainter(image!, rect),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class PuzzlePiecePainter extends CustomPainter {
  final ui.Image image;
  final Rect rect;

  PuzzlePiecePainter(this.image, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImageRect(image, rect, Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
