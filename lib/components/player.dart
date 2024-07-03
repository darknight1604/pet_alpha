import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

final _random = Random();

class Player extends CustomPainterComponent with HasGameReference<MyGame> {
  final _size = 50.0;

  @override
  Future<void> onLoad() async {
    painter = _PlayerThornCustomPainter(
      color: Colors.orangeAccent,
    );
    size = Vector2.all(_size);

    x = game.canvasSize.x * 0.5;
    y = game.canvasSize.y * 0.75;
  }

  @override
  void update(double dt) {}
}

class _PlayerThornCustomPainter extends CustomPainter {
  final Color color;

  _PlayerThornCustomPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0
      ..style = PaintingStyle.stroke;

    final x = size.width;
    final y = size.height;
    canvas.drawPath(
      Path()
        ..lineTo(0, y)
        ..lineTo(x, y)
        ..lineTo(x, 0)
        ..lineTo(0, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
