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
    _timer.update(dt);
    // if (gameOver) {
    //   removeAll(children.whereType<cpn.Thorn>());
    //   removeAll(children.whereType<cpn.Player>());
    //   _timer.reset();
    // }
  }
}
