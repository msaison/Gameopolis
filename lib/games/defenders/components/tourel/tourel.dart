import 'dart:math';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/extensions.dart';
import 'package:gameopolis/games/defenders/components/tourel/components/projectile.dart';
import 'package:gameopolis/games/defenders/game.dart';

////////////////////////////////////////
//////////// TOUREL MANAGER ////////////
////////////////////////////////////////

class TourelManager extends Component with HasGameRef<DefendersGame> {
  double _timeSinceLastSecond = 0;

  @override
  void update(double dt) {
    for (var element in gameRef.tourel) {
      if (element.isAdded) {
        if (element.component.distance(gameRef.enemy) <= 400) {
          _timeSinceLastSecond += dt;

          if (_timeSinceLastSecond >= 1.0) {
            if (gameRef.enemy.life > 0) add(ProjectileComponent(gameRef.spriteImage, gameRef.enemy.position, element.endpoint, 2));
            _timeSinceLastSecond = 0;
          }

          element.component.lookAt(gameRef.enemy.position);
        }
      }

      if (element.canBeAdded() && !element.isAdded) {
        add(element.addTourel()!);
      }
    }
    super.update(dt);
  }
}

////////////////////////////////////////
////////////////////////////////////////

////////////////////////////////////////
////////// CLASS TOUREL INFO ///////////
////////////////////////////////////////

class TourelInfo {
  TourelInfo({
    this.srcPosSkin,
    this.srcSizeSkin,
    required this.position,
    required this.size,
    required this.number,
    required this.spriteImage,
    this.damage,
    this.vitesse,
  }) : super();

  double? damage;
  double? vitesse;
  Vector2? srcSizeSkin;
  Vector2? srcPosSkin;
  final Vector2 position;
  final Vector2 size;
  final int number;
  final Image spriteImage;

  bool isAdded = false;

  void setup({
    required double damage_,
    required double vitesse_,
    required Vector2 srcSizeSkin_,
    required Vector2 srcPosSkin_,
  }) {
    damage = damage_;
    vitesse = vitesse_;
    srcSizeSkin = srcSizeSkin_;
    srcPosSkin = srcPosSkin_;
  }

  bool canBeAdded() {
    if (damage != null && vitesse != null && srcPosSkin != null && srcSizeSkin != null) return true;
    return false;
  }

  late SpriteComponent _spriteComponent;

  SpriteComponent get component => _spriteComponent;

  Vector2 get endpoint {
    final radians = component.angle + pi / 2;
    final x = position.x + size.x / 2 + cos(radians) * -50;
    final y = position.y + size.y / 2 + sin(radians) * -50;
    return Vector2(x, y);
  }

  SpriteComponent? addTourel() {
    Sprite sprite = Sprite(spriteImage, srcSize: srcSizeSkin, srcPosition: srcPosSkin);
    _spriteComponent = SpriteComponent(
        sprite: sprite, position: Vector2((position.x + size.x / 2), (position.y + size.y / 2)), anchor: Anchor.center);
    isAdded = true;

    return _spriteComponent;
  }
}

////////////////////////////////////////
////////////////////////////////////////