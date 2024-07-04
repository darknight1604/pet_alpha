import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Flame.device.setLandscape();
  runApp(
    const GameWidget<MyGame>.controlled(
      gameFactory: MyGame.new,
    ),
  );
}
