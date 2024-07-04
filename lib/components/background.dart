import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:pet_alpha/my_game.dart';

class Background extends SvgComponent with HasGameReference<MyGame> {
  // @override
  // Future onLoad() async {
  //   svg = await Svg.load(Assets.images.background.keyName);
  //   size = Vector2(game.canvasSize.x, game.canvasSize.y);
  //   x = 0.0;
  //   y = 0.0;
  // }
}
