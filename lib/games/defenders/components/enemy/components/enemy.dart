import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:gameopolis/games/defenders/components/tourel/components/projectile.dart';
import 'package:gameopolis/games/defenders/game.dart';
import 'package:gameopolis/utils/utils.dart';

enum EnemyState { fantassin, marin, aviateur, sapeur }

class Enemy extends SpriteGroupComponent<EnemyState> with HasGameRef<DefendersGame>, CollisionCallbacks {
  Enemy({required this.enemyType}) : super(anchor: Anchor.center);

  final EnemyState enemyType;
  double life = 100;

  @override
  FutureOr<void> onLoad() async {
    sprites = {
      EnemyState.aviateur: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(1960, 1316)),
      EnemyState.fantassin: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(2088, 1316)),
      EnemyState.marin: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(2216, 1316)),
      EnemyState.sapeur: Sprite(gameRef.spriteImage, srcSize: Vector2(48, 60), srcPosition: Vector2(2344, 1316))
    };
    add(CircleHitbox());

    size = Vector2(48 * gameRef.scale.x, 60 * gameRef.scale.y);
    current = enemyType;
    angle = direction['up']!;

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ProjectileComponent) {
      if (other.isMounted) {
        life -= 10;
        other.removeFromParent();
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void changePlayer(EnemyState enemy) {
    current = enemy;
  }
}
