// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

class GetSprite extends SpriteComponent with HasGameRef<FlappyBirdGame>, TapCallbacks {
  GetSprite(
      {required Vector2 srcPos,
      required Vector2 srcSi,
      bool scale = false,
      required Vector2 Function(Vector2 size) pos,
      void Function()? onTap,
      Anchor? anchor,
      bool isCollide = false})
      : _srcPos = srcPos,
        _srcSi = srcSi,
        _scale = scale,
        _pos = pos,
        _onTap = onTap,
        _isCollide = isCollide,
        super(anchor: anchor);

  final Vector2 _srcPos;
  final Vector2 _srcSi;
  final bool _scale;
  final Vector2 Function(Vector2 size) _pos;
  final void Function()? _onTap;
  final bool _isCollide;

  @override
  void onTapUp([TapUpEvent? event]) => _onTap?.call();

  @override
  Future<void> onLoad() async {
    sprite = Sprite(gameRef.spriteImageFlappy, srcPosition: _srcPos, srcSize: _srcSi);
    position = _pos(gameRef.size);

    if (_isCollide && !isRemoved) {
      add(
        RectangleHitbox()
          ..collisionType = CollisionType.active
          ..paint = paintCollision
          ..renderShape = true
      );
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    if (!_scale) {
      size = gameSize;
    } else {
      size = Vector2((_srcSi.x * (gameSize.x / screenSize.width)), _srcSi.y * (gameSize.y / screenSize.height));
      position = _pos(gameSize);
    }
  }
}
