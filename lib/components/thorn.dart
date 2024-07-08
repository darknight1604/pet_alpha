import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/components/player.dart';
import 'package:pet_alpha/game_setting.dart';
import 'package:pet_alpha/my_game.dart';

class Thorn extends CustomPainterComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final _size = 50.0;
  final _minimumDistance = 50;

  @override
  Future<void> onLoad() async {
    painter = _TriangularThornCustomPainter(
      // color: Color.fromRGBO(
      //   _random.nextInt(256),
      //   _random.nextInt(256),
      //   _random.nextInt(256),
      //   _random.nextDouble(),
      // ),
      color: Colors.greenAccent,
    );
    size = Vector2.all(_size);
    final alpha = _random.nextInt(_minimumDistance);
    x = game.canvasSize.x + _minimumDistance + alpha;
    y = game.canvasSize.y * GameSetting.platformHeightAlpha - _size;
    final vertices = [
      Vector2(x + _size / 2, y),
      Vector2(x, y + _size),
      Vector2(x + _size, y + _size),
    ];
    final hitbox = PolygonHitbox(
      vertices,
      position: Vector2.zero(), // IMPORTANT
    );

    add(hitbox);
  }

  @override
  void update(double dt) {
    x -= GameSetting.gameSpeed;
    if (x < 0 - _size) {
      game.remove(this);
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      game.gameOver = true;
      // game.pauseEngine();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  Random get _random => game.random;
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
