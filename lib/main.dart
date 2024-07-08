import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pet_alpha/my_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Flame.device.setLandscape();
  // runApp(
  //   GameWidget<MyGame>.controlled(
  //     gameFactory: MyGame.new,
  //     overlayBuilderMap: {
  //       'PauseMenu': (context, game) {
  //         return Container(
  //           color: const Color(0xFF000000),
  //           child: const Text('A pause menu'),
  //         );
  //       },
  //     },
  //   ),
  // );
  runApp(
    GameWidget(
      game: MyGame(),
      overlayBuilderMap: {
        'PauseMenu': (context, MyGame game) {
          return Container(
            color: const Color(0xFF000000),
            child: const Text('A pause menu'),
          );
        },
      },
    ),
  );
}
