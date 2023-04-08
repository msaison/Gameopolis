import 'package:flame/components.dart';

import 'package:flame/parallax.dart';
import 'package:gameopolis/games/runner/runner_game.dart';

class RunnerParralax extends ParallaxComponent<RunnerGame> {

  @override
  Future<void> onLoad() async {
    y = -270;

    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('runner_parralax/10_distant_clouds.png'),
        ParallaxImageData('runner_parralax/09_distant_clouds1.png'),
        ParallaxImageData('runner_parralax/08_clouds.png'),
        ParallaxImageData('runner_parralax/07_huge_clouds.png'),
        ParallaxImageData('runner_parralax/06_hill2.png'),
        ParallaxImageData('runner_parralax/05_hill1.png'),
        ParallaxImageData('runner_parralax/04_bushes.png'),
        ParallaxImageData('runner_parralax/03_distant_trees.png'),
        ParallaxImageData('runner_parralax/02_trees and bushes.png'),
      ],
      baseVelocity: Vector2(0, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    y = -(270 * (size.y / 1080));
    super.onGameResize(size);
  }
}
