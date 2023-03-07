import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:gameopolis/games/flappybird/components/get_sprite.dart';
import 'package:gameopolis/games/flappybird/game.dart';

class GetReady extends Component with HasGameRef<FlappyBirdGame> {
  GetReady() : super();

  bool visible = false;

  @override
  Future<void> onLoad() async {
    addAll([
      GetSprite(
        srcPos: Vector2(295, 59),
        srcSi: Vector2(92, 26),
        scale: true,
        pos: (size) => Vector2(size.x / 2, size.y * 0.3),
        anchor: Anchor.center,
      ),
      GetSprite(
        srcPos: Vector2(292, 91),
        srcSi: Vector2(57, 49),
        scale: true,
        pos: (size) => Vector2(size.x * 0.5, size.y * 0.5),
        anchor: Anchor.center,
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
