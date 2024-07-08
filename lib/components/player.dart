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
      secondColor: Colors.greenAccent,
      centerColor: Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextDouble(),
      ),
    );
    size = Vector2.all(_size);

    position = Vector2(game.canvasSize.x * 0.5, _baseY);
    anchor = Anchor.center;

    _timer = Timer(
      0.15,
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
    if (game.gameOver) {
      return;
    }
    if (_isJump || y != _baseY) {
      return;
    }
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
    // final tinyPlayerSize = Vector2.all(1 + _random.nextDouble() * _size * 0.2);
    final tinyPlayerSize = Vector2.all(4);
    final position = Vector2(
      x - tinyPlayerSize.x - _size * 0.5,
      y + _size * 0.5 - tinyPlayerSize.y,
    );
    game.add(
      TinyPlayer(
        size: tinyPlayerSize,
        position: position,
        color: Colors.yellowAccent,
        opacity: 1,
      ),
    );
    game.add(
      TinyPlayer(
        size: tinyPlayerSize,
        position: position,
        color: Color.fromRGBO(
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextDouble(),
        ),
        opacity: 1,
        isFly: _random.nextBool(),
      ),
    );
    game.add(
      TinyPlayer(
        size: tinyPlayerSize,
        position: position,
        color: Color.fromRGBO(
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextDouble(),
        ),
        opacity: 1,
        isFly: _random.nextBool(),
      ),
    );
  }
}

class TinyPlayer extends CustomPainterComponent
    with HasGameReference<MyGame>
    implements OpacityProvider {
  final Color color;
  final bool isFly;

  @override
  double opacity;

  TinyPlayer({
    required this.color,
    required this.opacity,
    super.size,
    super.position,
    this.isFly = false,
  });

  late Timer _timer;

  @override
  Future<void> onLoad() async {
    painter = _TinyPlayerCustomPainter(
      color: color,
      paintingStyle: PaintingStyle.fill,
    );
    _timer = Timer(
      1,
      onTick: () {
        game.remove(this);
      },
    );
    add(
      OpacityEffect.fadeOut(EffectController(duration: 1)),
    );
  }

  @override
  void update(double dt) {
    x -= 1;
    if (isFly) {
      y -= 0.2;
    }
    _timer.update(dt);
  }
}

class _TinyPlayerCustomPainter extends CustomPainter {
  final Color color;
  final PaintingStyle paintingStyle;

  _TinyPlayerCustomPainter({
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

class _PlayerCustomPainter extends CustomPainter {
  final Color color;
  final Color secondColor;
  final Color centerColor;

  _PlayerCustomPainter({
    required this.color,
    required this.secondColor,
    required this.centerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    const double scaleHeight = 0.25;

    final x = size.width;
    final y = size.height;
    final path = Path()
      ..lineTo(0, y)
      ..lineTo(x * scaleHeight, y * (1 - scaleHeight))
      ..lineTo(x * scaleHeight, y * scaleHeight)
      ..lineTo(x * (1 - scaleHeight), y * scaleHeight)
      ..lineTo(x, 0)
      ..lineTo(0, 0);
    canvas.drawPath(path, paint);

    final path2 = Path()
      ..moveTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..lineTo(x * scaleHeight, y * (1 - scaleHeight))
      ..lineTo(x * (1 - scaleHeight), y * (1 - scaleHeight))
      ..lineTo(x * (1 - scaleHeight), y * scaleHeight)
      ..lineTo(x, 0);
    canvas.drawPath(
      path2,
      paint..color = secondColor,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(x * 0.5, y * 0.5),
        width: 10,
        height: 10,
      ),
      paint..color = centerColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
