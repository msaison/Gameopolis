import 'dart:async';

import 'package:flame/components.dart';
import 'package:gameopolis/games/defenders/components/enemy/components/enemy.dart';
import 'package:gameopolis/games/defenders/components/enemy/components/lifebar.dart';
import 'package:gameopolis/games/defenders/game.dart';
import 'package:gameopolis/utils/utils.dart';

class EnemyMain extends PositionComponent with HasGameRef<DefendersGame> {
  final Enemy _enemy = Enemy(enemyType: EnemyState.fantassin);
  double life = 100;
  String? _end;
  final LifeBar _lifeBar = LifeBar(100);

  @override
  FutureOr<void> onLoad() {
    position = gameRef.spawnEnemy;
    _lifeBar.currentLife = life;
    _lifeBar.y = -15;
    _lifeBar.x = -13;

    add(_enemy);
    add(_lifeBar);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (_end != 'destroy') _end = movePlayerToPositions(gameRef.pathPos, this, _enemy, 100, dt);
    if(_lifeBar.currentLife >= 0) _lifeBar.currentLife--;
    super.update(dt);
  }
}

String? movePlayerToPositions(List<Tuple2<Vector2, String>> positions, EnemyMain enemyMain, Enemy enemy, double stepSize, double deltaTime) {
  if (positions.isEmpty) {
    return null;
  }
  var targetPosition = positions.first.first;
  var direction_ = (targetPosition - enemyMain.position).normalized();
  var distance = (targetPosition - enemyMain.position).distanceTo(Vector2.zero());
  var moveDistance = stepSize * deltaTime;

  if (moveDistance >= distance) {
    enemyMain.position = targetPosition;
    if (positions.first.second == 'end') {
      return ('destroy');
    }
    enemy.angle = direction[positions.first.second]!;
    positions.removeAt(0);
  } else {
    enemyMain.position += direction_ * moveDistance;

  }
  return null;
}