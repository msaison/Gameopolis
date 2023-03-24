// ignore_for_file: invalid_use_of_internal_member
import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gameopolis/games/flappybird/components/pipe/pipe.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

class PipeManager extends Component with HasGameRef<FlappyBirdGame> {
  late AudioPool _point;

  final Queue<PositionComponent> pipeQeue = Queue();
  bool _first = true;
  double _posRdmRange = 0;
  double _scored = 0;
  double _scale = 0;

  @override
  FutureOr<void> onLoad() async {
    _point = await FlameAudio.createPool(
      'sfx/point.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
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
    if (_first) {
      if (!pipeQeue.first.isMounted) add(pipeQeue.first..y = Random().nextDouble() * _posRdmRange);
      if (pipeQeue.first.x <= -((gameRef.size.x / 2)) && !pipeQeue.elementAt(1).isMounted) {
        add(pipeQeue.elementAt(1)..y = Random().nextDouble() * _posRdmRange);
      }
      if (pipeQeue.first.x <= -gameRef.size.x && !pipeQeue.last.isMounted) {
        add(pipeQeue.last..y = Random().nextDouble() * _posRdmRange);
        _first = false;
      }
    }

    if (pipeQeue.first.x <= -(gameRef.size.x + (gameRef.size.x / 2))) {
      //TODO FIX RANDOM RANGE PIPE
      // double _rdm = Random().nextDouble() * _posRdmRange;
      // print('y = ${pipeQeue.last.y} |  ${Random().nextDouble() * _posRdmRange}');
      pipeQeue.addLast(pipeQeue.removeFirst()
        ..x = 0
        ..y = Random().nextDouble() * _posRdmRange);
    }

    for (var element in pipeQeue) {
      if ((element.x).ceil() == -(_scored).ceil()) {
        gameRef.textScore.updateText((int.parse(gameRef.textScore.text) + 1).toString());
        _point.start(volume: 0.5);
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
