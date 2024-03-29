import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gameopolis/games/flappybird/components/get_sprite.dart';
import 'package:gameopolis/games/flappybird/components/ground.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

enum PlayerState { crashed, jumping, falling, waiting }

enum PlayerColor { blue, red, yellow }

class BirdPlayer extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  BirdPlayer({required Vector2 pos})
      : _resetPos = pos,
        super(anchor: Anchor.center, position: pos);

  late AudioPool _jumpSound;
  late AudioPool _dieSound;
  late AudioPool _hitSound;

  final double jumpSpeed = -250.0;
  final double fallingConstant = -600.0;
  final Vector2 birdSize = Vector2(17, 12);
  final Vector2 _resetPos;

  final Map<PlayerColor, List<Vector2>> _playerColorMap = {
    PlayerColor.blue: [Vector2(3, 499), Vector2(31, 499), Vector2(59, 499), Vector2(87, 499)],
    PlayerColor.red: [Vector2(115, 381), Vector2(115, 407), Vector2(115, 433)],
    PlayerColor.yellow: [Vector2(3, 485), Vector2(31, 485), Vector2(59, 485), Vector2(87, 485)],
  };

  double _vertSpeed = 0.0;

  PlayerColor playerColor = PlayerColor.yellow;

  @override
  Future<void> onLoad() async {
    _jumpSound = await FlameAudio.createPool(
      'sfx/wing.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );

    _hitSound = await FlameAudio.createPool(
      'sfx/hit.ogg',
      minPlayers: 1,
      maxPlayers: 2,
    );

    _dieSound = await FlameAudio.createPool(
      'sfx/die.ogg',
      minPlayers: 1,
      maxPlayers: 2,
    );

    final birdAnim = _getAnimation(size: birdSize, frames: _playerColorMap[playerColor]!);
    final birdNotAnim = _getAnimation(size: birdSize, frames: [_playerColorMap[playerColor]![0]]);

    animations = {
      PlayerState.waiting: birdAnim,
      PlayerState.jumping: birdAnim,
      PlayerState.falling: birdAnim,
      PlayerState.crashed: birdNotAnim,
    };

    current = PlayerState.waiting;

    size = Vector2(birdSize.x * gameRef.size.x / screenSize.width, birdSize.y * gameRef.size.y / screenSize.height);

    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.9, size.y * 0.9),
        position: Vector2(size.x * 0.05, size.y * 0.05),
      )
        ..collisionType = CollisionType.active
        ..paint = paintCollision
        ..renderShape = true,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    Vector2 birdSize =
        Vector2(this.birdSize.x * size.x / screenSize.width, this.birdSize.y * size.y / screenSize.height);

    this.size = birdSize;
  }

  void jump() {
    _jumpSound.start(volume: 0.4);
    if (current == PlayerState.jumping) {
      return;
    }
    current = PlayerState.jumping;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (gameRef.isGameOver) {
      if (other is GetSprite) {
        return;
      } else {
        gameRef.gameOver();
        current = PlayerState.crashed;
        _vertSpeed = 0;
      }
    }
    if (other is GetSprite || other is Ground && gameRef.isPlaying) {
      _hitSound.start(volume: 0.4);
      gameRef.gameOver();
      current = PlayerState.crashed;
      _dieSound.start(volume: 0.4);
      _vertSpeed = 0;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) async {
    super.update(dt);
    _jump(dt);
    _crashed(dt);
    _waiting();
  }

  void _waiting() {
    if (gameRef.isGetReady) {
      current = PlayerState.waiting;
      position = _resetPos;
      angle = 0.0;
    }
  }

  void _crashed(double dt) {
    if (current == PlayerState.crashed) {
      y += _vertSpeed * dt;
      _vertSpeed -= fallingConstant * dt;

      if (angle < 1.6) {
        angle += (2.5 + (angle / 5)) * dt;
      }
    }
  }

  void _jump(double dt) {
    if (current == PlayerState.jumping) {
      _vertSpeed = jumpSpeed;
      angle = -0.7;
      current = PlayerState.falling;
    }
    if (current == PlayerState.falling) {
      y += _vertSpeed * dt;
      _vertSpeed -= fallingConstant * dt;

      if (angle < 1.6) {
        angle += (2.5 + (angle / 5)) * dt;
      }
    }
  }

  SpriteAnimation _getAnimation({
    required Vector2 size,
    required List<Vector2> frames,
    double stepTime = 0.06,
  }) {
    return SpriteAnimation.spriteList(
      frames
          .map(
            (vector) => Sprite(
              gameRef.spriteImageFlappy,
              srcSize: size,
              srcPosition: vector,
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
