// import 'package:flame/components.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/components.dart' as cpn;

class MyGame extends FlameGame {
  // final _world = World();
  final gameSpeed = 1;

  late Timer _timer;
  final _timeCreateThorn = 2.0;

  @override
  Future<void> onLoad() async {
    add(cpn.Platform());

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
  }
}
