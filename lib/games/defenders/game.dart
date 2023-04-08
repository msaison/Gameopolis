import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

class DefendersGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, HasGameRef<DefendersGame>, HasTappableComponents {

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }
}
