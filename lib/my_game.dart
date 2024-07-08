import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/components.dart' as cpn;

class MyGame extends FlameGame with HasCollisionDetection {
  // final _world = World();

  late Timer _timer;
  final _timeCreateThorn = 5.0;
  final random = Random();
  var gameOver = false;

  Vector2 get centerPosition => Vector2(canvasSize.x * 0.5, canvasSize.y * 0.5);

  @override
  Future<void> onLoad() async {
    add(cpn.Platform());
    add(cpn.Player());

    _timer = Timer(
      _timeCreateThorn,
      repeat: true,
      onTick: () {
        add(cpn.Thorn());
      },
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameOver) {
      add(cpn.Replay());
      // overlays.add('PauseMenu');
      Future.delayed(const Duration(milliseconds: 20), () => pauseEngine());
      return;
    }
    _timer.update(dt);
  }

  void resetGame() {
    gameOver = false;
    // overlays.remove('PauseMenu');
    removeWhere((component) {
      return component is cpn.Thorn;
    });

    Future.delayed(const Duration(milliseconds: 20), () => resumeEngine());
  }
}
