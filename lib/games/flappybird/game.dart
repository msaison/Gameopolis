import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:gameopolis/games/flappybird/components/bird.dart';
import 'package:gameopolis/games/flappybird/components/get_sprite.dart';
import 'package:gameopolis/games/flappybird/components/ground.dart';
import 'package:gameopolis/games/flappybird/components/pipe/pipe_manager.dart';
import 'package:gameopolis/games/flappybird/components/text.dart';
import 'package:gameopolis/games/flappybird/panels/gameover.dart';
import 'package:gameopolis/games/flappybird/panels/intro.dart';
import 'package:gameopolis/games/flappybird/panels/getready.dart';

enum GameState { playing, intro, gameOver, getReady }

class FlappyBirdGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, HasGameRef<FlappyBirdGame> {
  FlappyBirdGame();

  static const String description = '''
    A game similar to the game in chrome that you get to play while offline.
    Press space or tap/click the screen to jump, the more obstacles you manage
    to survive, the more points you get.
  ''';

  late final Image spriteImageFlappy;

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  late final background =
      GetSprite(srcPos: Vector2(0, 0), srcSi: Vector2(144, 256), pos: (n) => Vector2(0, 0), anchor: Anchor.topLeft);
  late final pipe = PipeManager();
  late final textScore = TextUpdate('');
  late final ground = Ground();
  late final player = BirdPlayer(pos: Vector2(gameRef.size.x * 0.30, gameRef.size.y * 0.4));
  late final introPanel = Intro();
  late final getReadyPanel = GetReady();
  late final gameOverPanel = GameOverPanel();
  late Vector2 textPosition = Vector2(0, 0);

  int score = 0;
  int _highscore = 0;

  double currentSpeed = 200;

  String scoreString(int score) => score.toString().padLeft(5, '0');

  @override
  Future<void> onLoad() async {
    spriteImageFlappy = await Flame.images.load('sprites.png');
    add(background);
    add(pipe);
    add(ground);
    add(textScore);
    add(player);
    add(gameOverPanel);
    add(getReadyPanel);
    add(introPanel);
  }

  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isGetReady => state == GameState.getReady;
  bool get isIntro => state == GameState.intro;

  void onTapUp(TapUpEvent event) {
    onAction();
    // super.onTapUp(event);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      gameOver();
    }
    if (keysPressed.contains(LogicalKeyboardKey.enter) || keysPressed.contains(LogicalKeyboardKey.space)) {
      onAction();
    }
    return KeyEventResult.handled;
  }

  void onAction() {
    if (isGetReady) start();
    if (isPlaying) player.jump();
  }

  void gameOver() {
    _highscore = score;
    state = GameState.gameOver;
    ground.reset();
    score = 0;
    gameOverPanel.visible = true;
    textScore.updateText('');
  }

  void getReady() {
    state = GameState.getReady;
    if (!introPanel.isRemoved) remove(introPanel);
    getReadyPanel.visible = true;
    textScore.updateText(score.toString());
    pipe.reset();
  }

  void start() {
    state = GameState.playing;
    getReadyPanel.visible = false;
  }
}
