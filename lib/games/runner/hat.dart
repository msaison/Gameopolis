import 'dart:async';

import 'package:flame/components.dart';
import 'package:gameopolis/games/runner/runner_game.dart';

enum HatState { first, second, third }

class HatComponent extends SpriteGroupComponent<HatState> with HasGameRef<RunnerGame> {
  HatComponent({
    required super.position,
    required super.size,
    super.current,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  int hatn = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprites = {
      HatState.first: Sprite(
        gameRef.spriteImage,
        srcPosition: Vector2(954, 52),
        srcSize: Vector2(22, 19),
      ),
      HatState.second: Sprite(
        gameRef.spriteImage,
        srcPosition: Vector2(978, 52),
        srcSize: Vector2(36, 5),
      ),
      HatState.third: Sprite(
        gameRef.spriteImage,
        srcPosition: Vector2(1019, 52),
        srcSize: Vector2(32, 32),
      ),
    };

    current = HatState.first;
  }

  @override
  void update(double dt) {
    if (hatn == 0) current = HatState.first;
    if (hatn == 1) current = HatState.second;
    if (hatn == 2) current = HatState.third;
    super.update(dt);
  }
}
