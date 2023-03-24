import 'dart:async';

import 'package:flame/components.dart';
import 'package:gameopolis/games/flappybird/components/get_sprite.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

class Pipe extends PositionComponent with HasGameRef<FlappyBirdGame> {
  Pipe({this.ecart = 55.0}) : super();
  final double ecart;

  @override
  FutureOr<void> onLoad() {
    add(GetSprite(
      srcPos: Vector2(0, 323),
      srcSi: Vector2(26, 160),
      scale: true,
      pos: (size) => Vector2(size.x, size.y / 5.5 + ((ecart * size.y / screenSize.height) / 2)),
      anchor: Anchor.topLeft,
      isCollide: true,
    ));
    add(GetSprite(
      srcPos: Vector2(28, 323),
      srcSi: Vector2(26, 160),
      scale: true,
      pos: (size) => Vector2(size.x, size.y / 5.5 - ((ecart * size.y / screenSize.height) / 2)),
      anchor: Anchor.bottomLeft,
      isCollide: true,
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    final increment = gameRef.currentSpeed * dt;
    if (gameRef.isPlaying) x -= increment;

    super.update(dt);
  }
}
