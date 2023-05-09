import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class ProjectileComponent extends PositionComponent {
  late Sprite fireSprite;
  late PositionComponent projectileSprite;
  late CircleHitbox hitbox;
  final Image image;
  final Vector2 target;
  final Vector2 startPos;
  late double vitesse;

  ProjectileComponent(this.image, this.target, this.startPos, this.vitesse) : super(anchor: Anchor.center, position: startPos) {
    // fireSprite = Sprite(image, srcSize: Vector2(34, 56), srcPosition: Vector2(2480, 1572));
    Sprite sprite = Sprite(image, srcSize: Vector2(32, 32), srcPosition: Vector2(2864, 1456));
    projectileSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);
    hitbox = CircleHitbox(radius: 16, anchor: Anchor.center);
  }

  @override
  FutureOr<void> onLoad() {
    add(hitbox);
    add(projectileSprite);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.moveToTarget(target, vitesse);
    super.update(dt);
  }
}
