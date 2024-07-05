import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/game_setting.dart';
import 'package:pet_alpha/my_game.dart';

class Player extends CustomPainterComponent
    with HasGameReference<MyGame>, TapCallbacks {
  final _size = 50.0;
  final _maximumHeightJumpable = 120.0;
  var _isJump = false;
  final _speedJump = 2.0;
  late Timer _timer;

  Random get _random => game.random;
  double get _baseY =>
      game.canvasSize.y * GameSetting.platformHeightAlpha - _size * 0.5;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());

    painter = _PlayerCustomPainter(
      color: Colors.orangeAccent,
    );
    size = Vector2.all(_size);

    position = Vector2(game.canvasSize.x * 0.5, _baseY);
    anchor = Anchor.center;

    _timer = Timer(
      0.25,
      repeat: true,
      onTick: _onTick,
    );
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    if (_isJump) {
      if (_baseY - y <= _maximumHeightJumpable) {
        y -= _speedJump;
        return;
      }
      _isJump = false;
      y = _baseY - _maximumHeightJumpable;
      return;
    }
    if (y < _baseY) {
      y += _speedJump;
      return;
    }
    if (y >= _baseY) {
      y = _baseY;
      return;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isJump = true;

    add(
      RotateEffect.by(
        tau / 2,
        EffectController(duration: 2),
      ),
    );
  }

  void _onTick() {
    if (_isJump || y != _baseY) {
      return;
    }
    final tinyPlayerSize = Vector2.all(1 + _random.nextDouble() * _size * 0.2);
    final position = Vector2(
      x - tinyPlayerSize.x - _size * 0.5,
      y + _size * 0.5 - tinyPlayerSize.y,
    );
    game.add(
      TinyPlayer(
        size: tinyPlayerSize,
        position: position,
        // color: Color.fromRGBO(
        //   _random.nextInt(256),
        //   _random.nextInt(256),
        //   _random.nextInt(256),
        //   _random.nextDouble(),
        // ),
        color: Colors.yellowAccent,
      ),
    );
  }
}

class TinyPlayer extends CustomPainterComponent with HasGameReference<MyGame> {
  final Color color;
  TinyPlayer({
    required this.color,
    super.size,
    super.position,
  });

  late Timer _timer;

  @override
  Future<void> onLoad() async {
    painter = _PlayerCustomPainter(
      color: color,
      paintingStyle: PaintingStyle.fill,
      forTiny: true,
    );
    _timer = Timer(
      2,
      onTick: () {
        game.remove(this);
      },
    );
  }

  @override
  void update(double dt) {
    x -= 1;
    _timer.update(dt);
  }
}

class _PlayerCustomPainter extends CustomPainter {
  final Color color;
  final PaintingStyle paintingStyle;
  final bool forTiny;

  _PlayerCustomPainter({
    required this.color,
    this.paintingStyle = PaintingStyle.stroke,
    this.forTiny = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0
      ..style = paintingStyle;

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

    if (forTiny) {
      return;
    }

    canvas.drawCircle(Offset(x * 0.25, y * 0.25), 10, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
