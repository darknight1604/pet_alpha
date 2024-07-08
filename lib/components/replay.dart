import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

class Replay extends CustomPainterComponent
    with HasGameReference<MyGame>, TapCallbacks {
  final _componentSize = 48.0;
  @override
  void onLoad() {
    position = game.centerPosition;
    painter = _ReplayCustomPainter(color: Colors.white);
    size = Vector2.all(_componentSize);
    anchor = Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    // add(
    //   RotateEffect.by(
    //     tau,
    //     EffectController(duration: 2),
    //   ),
    // );

    game.resetGame();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameOver) {
      return;
    }
    if (!isMounted) {
      return;
    }
    removeFromParent();
  }
}

class _ReplayCustomPainter extends CustomPainter {
  final Color color;

  _ReplayCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final widthBigArc = size.width;
    final heightBigArc = size.height;

    const sweepAngle1 = (7 * pi) / 4;
    final radius1 = size.width * 0.3;
    final radian1 = _degreeToRadians(315);
    final offset1 = Offset(
      radius1 * cos(radian1) + center.dy,
      radius1 * sin(radian1) + center.dx,
    );

    canvas.drawPath(
      Path()
        ..moveTo(widthBigArc, size.height * 0.5)
        ..addArc(
          Rect.fromCenter(
            center: center,
            width: widthBigArc,
            height: heightBigArc,
          ),
          0,
          sweepAngle1,
        )
        ..lineTo(
          size.width,
          0,
        )
        ..lineTo(
          size.width,
          size.height * 0.4,
        )
        ..lineTo(
          size.width * 0.6,
          size.height * 0.4,
        )
        ..lineTo(offset1.dx, offset1.dy)
        ..addArc(
          Rect.fromCenter(
            center: center,
            width: size.width * 0.6,
            height: size.width * 0.6,
          ),
          sweepAngle1,
          -sweepAngle1,
        )
        ..lineTo(widthBigArc, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  double _degreeToRadians(double degree) {
    return (pi / 180) * degree;
  }
}
