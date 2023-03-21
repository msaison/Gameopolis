// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:gameopolis/games/flappybird/components/pipe/pipe.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

class PipeManager extends Component with HasGameRef<FlappyBirdGame> {
  final Queue<PositionComponent> pipeQeue = Queue();
  bool _first = true;
  double _posRdmRange = 0;
  double _scored = 0;
  double _scale = 0;

  @override
  FutureOr<void> onLoad() {
    _scale = gameRef.size.y / screenSize.height;
    _posRdmRange = 120 * _scale;
    _scored = (gameRef.size.y * 0.4) + (26 * _scale);
    final pipes = [Pipe(), Pipe(), Pipe()];
    pipeQeue.addAll(pipes);
    return super.onLoad();
  }

  void reset() {
    removeAll(children);
    pipeQeue.clear();
    _first = true;
    final pipes = [Pipe(), Pipe(), Pipe()];
    pipeQeue.addAll(pipes);
  }

  void _updatePipes() {
    if (!pipeQeue.first.isMounted && _first) add(pipeQeue.first..y = Random().nextDouble() * _posRdmRange);
    if (pipeQeue.first.x <= -((gameRef.size.x / 2)) && _first && !pipeQeue.elementAt(1).isMounted) {
      add(pipeQeue.elementAt(1)..y = Random().nextDouble() * _posRdmRange);
    }
    if (pipeQeue.first.x <= -gameRef.size.x && _first && !pipeQeue.last.isMounted) {
      add(pipeQeue.last..y = Random().nextDouble() * _posRdmRange);
      _first = false;
    }

    if ((pipeQeue.last.x).ceil() == -(gameRef.size.x / 2)) {
      pipeQeue.addLast(pipeQeue.removeFirst()
        ..x = 0
        ..y = Random().nextDouble() * _posRdmRange);
    }

    for (var element in pipeQeue) {
      if ((element.x).ceil() == -(_scored).ceil()) {
        gameRef.textScore.updateText((int.parse(gameRef.textScore.text) + 1).toString());
      }
    }
  }

  @override
  void update(double dt) {
    if (gameRef.isPlaying) _updatePipes();

    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    _scale = size.y / screenSize.height;
    _posRdmRange = 120 * _scale;
    _scored = (size.y * 0.4) + (26 * _scale);
    super.onGameResize(size);
  }
}
