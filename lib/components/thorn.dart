import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

final _random = Random();

class Thorn extends CustomPainterComponent with HasGameReference<MyGame> {
  final _size = 50.0;
  final _minimumDistance = 50;

  @override
  Future<void> onLoad() async {
    painter = _TriangularThornCustomPainter(
        color: Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextDouble(),
    ));
    size = Vector2.all(_size);
    final alpha = _random.nextInt(_minimumDistance);
    x = game.canvasSize.x + _minimumDistance + alpha;
    y = game.canvasSize.y * 0.5 - _size;
  }

  @override
  void update(double dt) {
    x -= game.gameSpeed;
    if (x < 0 - _size) {
      game.remove(this);
    }
  }
}

class _TriangularThornCustomPainter extends CustomPainter {
  final Color color;

  _TriangularThornCustomPainter({required this.color});
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
        ..moveTo(0, y)
        ..lineTo(x / 2, 0)
        ..lineTo(x, y)
        ..lineTo(0, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
