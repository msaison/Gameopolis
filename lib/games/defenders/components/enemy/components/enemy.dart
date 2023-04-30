import 'dart:async';

import 'package:flame/components.dart';
import 'package:gameopolis/games/defenders/game.dart';
import 'package:gameopolis/utils/utils.dart';

enum EnemyState { fantassin, marin, aviateur, sapeur }

class Enemy extends SpriteGroupComponent<EnemyState> with HasGameRef<DefendersGame> {
  Enemy({required this.enemyType}) : super(anchor: Anchor.center);

  final EnemyState enemyType;

  @override
  FutureOr<void> onLoad() async {
    sprites = {
      EnemyState.aviateur: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(1960, 1316)),
      EnemyState.fantassin: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(2088, 1316)),
      EnemyState.marin: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(2216, 1316)),
      EnemyState.sapeur: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(2344, 1316))
    };

    current = enemyType;
    angle = direction['up']!;

    return super.onLoad();
  }

  void changePlayer(EnemyState enemy) {
    current = enemy;
  }
}
