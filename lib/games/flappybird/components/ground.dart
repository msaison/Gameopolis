import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:gameopolis/games/flappybird/components/utils.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

class Ground extends PositionComponent with HasGameRef<FlappyBirdGame> {
  Ground() : super();

  static final Vector2 lineSize = Vector2(168, 56);
  final Queue<SpriteComponent> groundLayers = Queue();

  late final _mooveSprite = Sprite(
    gameRef.spriteImageFlappy,
    srcPosition: Vector2(292.0, 0),
    srcSize: lineSize,
  );

  double _sizeYground = 0;
  double get yground {
    return _sizeYground;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      size: Vector2(gameRef.size.x, _sizeYground),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = gameRef.currentSpeed * dt;
    if (gameRef.isPlaying) {
      for (final line in groundLayers) {
        line.x -= increment;
      }
    }

    final firstLine = groundLayers.first;
    if (firstLine.x <= -firstLine.width) {
      firstLine.x = groundLayers.last.x + groundLayers.last.width;
      groundLayers.remove(firstLine);
      groundLayers.add(firstLine);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final newLines = _generateLines();
    groundLayers.addAll(newLines);
    for (var element in groundLayers) {
      _sizeYground = lineSize.y * size.y / screenSize.height;
      element.size.y = _sizeYground;
    }
    addAll(newLines);
    y = (size.y - _sizeYground);
  }

  void reset() {
    groundLayers.forEachIndexed((line, i) => line.x = i * lineSize.x);
  }

  List<SpriteComponent> _generateLines() {
    final number = 1 + (gameRef.size.x / lineSize.x).ceil() - groundLayers.length;
    return List.generate(
      max(number, 0),
      (i) => SpriteComponent(
        position: Vector2(0, 0),
        sprite: _mooveSprite,
        size: lineSize,
      )..x = 0 + lineSize.x * i,
      growable: false,
    );
  }
}
