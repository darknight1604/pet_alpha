import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

class Platform extends CustomPainterComponent with HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    painter = _PlatformCustomPainter();
    size = Vector2(game.canvasSize.x, 0);
    // size = Vector2.all(game.canvasSize.x);

    y = game.canvasSize.y * 0.5;
  }
}

class _PlatformCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final point2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    canvas.drawLine(Offset.zero, point2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
