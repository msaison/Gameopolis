import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:gameopolis/games/flappybird/components/get_sprite.dart';
import 'package:gameopolis/games/flappybird/game.dart';

class Intro extends Component with HasGameRef<FlappyBirdGame> {
  Intro() : super();

  bool visible = true;

  @override
  Future<void> onLoad() async {
    addAll([
      GetSprite(
        srcPos: Vector2(351, 91),
        srcSi: Vector2(89, 24),
        scale: true,
        pos: (size) => Vector2(size.x / 2, size.y * 0.3),
        anchor: Anchor.center,
      ),
      GetSprite(
        srcPos: Vector2(354, 118),
        srcSi: Vector2(52, 29),
        scale: true,
        pos: (size) => Vector2(size.x * 0.5, size.y * 0.7),
        anchor: Anchor.center,
        onTap: () {
          if (gameRef.state == GameState.intro) {
            gameRef.getReady();
            visible = false;
          }
        },
      ),
    ]);
    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}
