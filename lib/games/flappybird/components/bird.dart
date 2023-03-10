import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

enum PlayerState { crashed, jumping, falling, waiting }

enum PlayerColor { blue, red, yellow }

class BirdPlayer extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  BirdPlayer({required Vector2 pos})
      : _resetPos = pos,
        super(anchor: Anchor.center, position: pos);

  final double jumpSpeed = -200.0;
  final double fallingConstant = -500.0;
  final Vector2 birdSize = Vector2(17, 12);
  final Vector2 _resetPos;

  final Map<PlayerColor, List<Vector2>> _playerColorMap = {
    PlayerColor.blue: [Vector2(87, 491), Vector2(115, 329), Vector2(115, 329)],
    PlayerColor.red: [Vector2(115, 381), Vector2(115, 407), Vector2(115, 433)],
    PlayerColor.yellow: [Vector2(3, 491), Vector2(31, 491), Vector2(59, 491)],
  };

  double _vertSpeed = 0.0;

  PlayerColor playerColor = PlayerColor.blue;

  @override
  Future<void> onLoad() async {
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

    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    Vector2 birdSize =
        Vector2(this.birdSize.x * size.x / screenSize.width, this.birdSize.y * size.y / screenSize.height);

    this.size = birdSize;
  }

  void jump() {
    if (current == PlayerState.jumping) {
      return;
    }
    current = PlayerState.jumping;
  }

  void resetPos() {
    position = _resetPos;
    angle = 0.0;
  }

  void reset() {
    _vertSpeed = 0.0;
    current = PlayerState.crashed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    gameRef.gameOver();
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (gameRef.isPlaying || current != PlayerState.crashed || current != PlayerState.waiting) {
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
  }

  SpriteAnimation _getAnimation({
    required Vector2 size,
    required List<Vector2> frames,
    double stepTime = 0.1,
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
