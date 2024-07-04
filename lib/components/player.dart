import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

class Player extends CustomPainterComponent
    with HasGameReference<MyGame>, TapCallbacks {
  final _size = 50.0;
  final _maximumHeightJumpable = 50.0;
  var _isJump = false;
  final _speedJump = 2.0;
  final _random = Random();
  late Timer _timer;

  double get _baseY => game.canvasSize.y * 0.75;

  @override
  Future<void> onLoad() async {
    painter = _PlayerThornCustomPainter(
      color: Colors.orangeAccent,
    );
    size = Vector2.all(_size);

    x = game.canvasSize.x * 0.5;
    y = _baseY;

    _timer = Timer(
      0.25,
      repeat: true,
      onTick: () {
        if (_isJump) {
          return;
        }
        final tinyPlayerSize =
            Vector2.all(1 + _random.nextDouble() * _size * 0.2);
        final position = Vector2(x, y + _size - tinyPlayerSize.y);
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
      },
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
    painter = _PlayerThornCustomPainter(
      color: color,
      paintingStyle: PaintingStyle.fill,
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

class _PlayerThornCustomPainter extends CustomPainter {
  final Color color;
  final PaintingStyle paintingStyle;

  _PlayerThornCustomPainter({
    required this.color,
    this.paintingStyle = PaintingStyle.stroke,
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
