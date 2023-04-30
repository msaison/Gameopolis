import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:gameopolis/games/defenders/game.dart';

////////////////////////////////////////
//////////// TOUREL MANAGER ////////////
////////////////////////////////////////

class TourelManager extends Component with HasGameRef<DefendersGame> {
  @override
  void update(double dt) {
    for (var element in gameRef.tourel) {
      if (element.canBeAdded()) {
        add(element.addTourel()!);
      }
    }
    super.update(dt);
  }
}

////////////////////////////////////////
////////////////////////////////////////

////////////////////////////////////////
/////////// TOUREL COMPONENT ///////////
////////////////////////////////////////

class Tourel extends SpriteComponent with HasGameRef<DefendersGame> {
  Tourel({required this.srcPosT, required this.srcSizeT, required this.position_}) : super(position: position_);

  final Vector2 srcSizeT;
  final Vector2 srcPosT;
  final Vector2 position_;

  late final Sprite _sprite;
  late final SpriteComponent _spriteComponent;

  @override
  FutureOr<void> onLoad() {
    _sprite = Sprite(gameRef.spriteImage, srcSize: srcSizeT, srcPosition: srcPosT);
    _spriteComponent = SpriteComponent(sprite: _sprite);
    _spriteComponent.position.x += 14;
    _spriteComponent.position.y += 5;
    sprite = Sprite(gameRef.spriteImage, srcSize: Vector2(104, 104), srcPosition: Vector2(2444, 908));

    add(_spriteComponent);
    return super.onLoad();
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
  });

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

  SpriteComponent? addTourel() {
      isAdded = true;
      return Tourel(srcPosT: srcPosSkin!, srcSizeT: srcSizeSkin!, position_: position);
  }
}

////////////////////////////////////////
////////////////////////////////////////
