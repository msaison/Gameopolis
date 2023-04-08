// ignore_for_file: depend_on_referenced_packages

import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:gameopolis/games/runner/obstacle/obstacle_manager.dart';
import 'package:gameopolis/games/runner/runner_game.dart';

class Horizon extends PositionComponent with HasGameRef<RunnerGame> {
  Horizon() : super();

  static final Vector2 lineSize = Vector2(1920, 540);
  final Queue<SpriteComponent> groundLayers = Queue();
  late final ObstacleManager obstacleManager = ObstacleManager();

  late final _groundSprite = Sprite(
    gameRef.ground,
    srcPosition: Vector2(0.0, 540.0),
    srcSize: lineSize,
  );

  @override
  Future<void> onLoad() async {
    add(obstacleManager);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = gameRef.currentSpeed * dt;
    for (final line in groundLayers) {
      line.x -= increment;
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
    addAll(newLines);
    y = (size.y / 2) + 45.0;
  }

  void reset() {
    obstacleManager.reset();
    groundLayers.forEachIndexed((i, line) => line.x = i * lineSize.x);
  }

  List<SpriteComponent> _generateLines() {
    final number = 1 + (gameRef.size.x / lineSize.x).ceil() - groundLayers.length;
    final lastX = (groundLayers.lastOrNull?.x ?? 0) + (groundLayers.lastOrNull?.width ?? 0);
    return List.generate(
      max(number, 0),
      (i) => SpriteComponent(
        sprite: _groundSprite,
        size: lineSize,
        // anchor: Anchor.bottomLeft
      )..x = lastX + lineSize.x * i,
      growable: false,
    );
  }
}
