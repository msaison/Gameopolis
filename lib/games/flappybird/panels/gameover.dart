import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:gameopolis/games/flappybird/components/get_sprite.dart';
import 'package:gameopolis/games/flappybird/game.dart';

class GameOverPanel extends Component with HasGameRef<FlappyBirdGame> {
  GameOverPanel() : super();

  bool visible = false;

  @override
  Future<void> onLoad() async {
    add(GetSprite(
      srcPos: Vector2(395, 59),
      srcSi: Vector2(96, 21),
      scale: true,
      pos: (size) => Vector2(size.x / 2, size.y * 0.3),
      anchor: Anchor.center,
    ));
    add(GetSprite(
        srcPos: Vector2(414, 118),
        srcSi: Vector2(52, 29),
        scale: true,
        pos: (size) => Vector2(size.x * 0.5, size.y * 0.7),
        anchor: Anchor.center,
        onTap: () {
          if (gameRef.state == GameState.gameOver) {
            gameRef.getReady();
            visible = false;
          }
        }));
    add(GetSprite(
      srcPos: Vector2(3, 259),
      srcSi: Vector2(113, 57),
      scale: true,
      pos: (size) => Vector2(size.x * 0.5, size.y * 0.5),
      anchor: Anchor.center,
    ));
    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}
