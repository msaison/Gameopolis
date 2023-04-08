import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gameopolis/games/runner/runner_game.dart';

enum PlayerState { crashed, jumping, running, waiting, die }

// enum HatState { first, second, third }

class Player extends SpriteAnimationGroupComponent<PlayerState> with HasGameRef<RunnerGame>, CollisionCallbacks {
  Player() : super(size: Vector2(90, 88));

  final double gravity = 1;

  final double initialJumpVelocity = -15.0;
  final double introDuration = 1500.0;
  final double startXPosition = 50;

  double _jumpVelocity = 0.0;

  double get groundYPos {
    return (gameRef.size.y / 2) - height / 2;
  }

  @override
  Future<void> onLoad() async {
    // Body hitbox
    add(
      RectangleHitbox.relative(
        Vector2(0.7, 0.6),
        position: Vector2(0, height / 3),
        parentSize: size,
      ),
    );
    // Head hitbox
    add(
      RectangleHitbox.relative(
        Vector2(0.45, 0.35),
        position: Vector2(width / 2, 0),
        parentSize: size,
      ),
    );
    animations = {
      PlayerState.running: _getAnimation(
        size: Vector2(23.0, 28.0),
        frames: [
          Vector2(0.0, 122.0),
          Vector2(50.0, 122.0),
          Vector2(99.0, 122.0),
          Vector2(150.0, 122.0),
          Vector2(200.0, 122.0),
          Vector2(250.0, 122.0),
        ],
        stepTime: 0.1,
      ),
      PlayerState.waiting: _getAnimation(
        size: Vector2(25.0, 28.0),
        frames: [
          Vector2(0.0, 151.0),
          Vector2(50.0, 151.0),
          Vector2(100.0, 151.0),
          Vector2(150.0, 151.0),
          // Vector2(200.0, 151.0),
        ],
        stepTime: 0.1,
      ),
      PlayerState.jumping: _getAnimation(
        size: Vector2(21.0, 27.0),
        frames: [
          Vector2(0.0, 122.0),
          Vector2(50.0, 122.0),
          Vector2(100.0, 122.0),
          Vector2(150.0, 122.0),
          Vector2(200.0, 122.0),
          Vector2(250.0, 122.0),
        ],
      ),
      PlayerState.crashed: _getAnimation(
        size: Vector2(21.0, 24.0),
        frames: [
          Vector2(0.0, 208.0),
          Vector2(50.0, 208.0),
          Vector2(100.0, 208.0),
          Vector2(150.0, 208.0),
          Vector2(200.0, 208.0),
          Vector2(250.0, 208.0),
          Vector2(300.0, 208.0),
        ],
        stepTime: 0.1,
      ),
      PlayerState.die: _getAnimation(
        size: Vector2(21.0, 24.0),
        frames: [
          Vector2(300.0, 208.0),
        ],
      ),
    };
    current = PlayerState.waiting;
  }

  void jump(double speed) {
    if (current == PlayerState.jumping) {
      return;
    }

    current = PlayerState.jumping;
    _jumpVelocity = initialJumpVelocity - (speed / 500);
  }

  void reset() {
    y = groundYPos;
    _jumpVelocity = 0.0;
    current = PlayerState.running;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == PlayerState.jumping) {
      y += _jumpVelocity;
      _jumpVelocity += gravity;
      if (y > groundYPos) {
        reset();
      }
    } else {
      y = groundYPos;
    }

    if (gameRef.isIntro && x < startXPosition) {
      x += (startXPosition / introDuration) * dt * 5000;
    }

    if (current == PlayerState.crashed && animation!.isLastFrame) {
      animation!.stepTime = double.infinity;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    y = groundYPos;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    super.onCollisionStart(intersectionPoints, other);
    gameRef.gameOver();
  }

  SpriteAnimation _getAnimation({
    required Vector2 size,
    required List<Vector2> frames,
    double stepTime = double.infinity,
  }) {
    return SpriteAnimation.spriteList(
      frames
          .map(
            (vector) => Sprite(
              gameRef.spriteImage,
              srcSize: size,
              srcPosition: vector,
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
