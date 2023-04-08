import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:flutter/material.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/games/runner/runner_game.dart';
import 'package:gameopolis/utils/utils.dart';

List<ShowGames> _games = [
  ShowGames(
      gameName: 'Runner',
      gameImage: const DecorationImage(image: AssetImage('assets/logo/t_rex_logo.png')),
      gameWidget: RunnerGame(),
      gameRatio: Vector2(16, 9)),
  ShowGames(
      gameName: 'Flappy Bird',
      gameWidget: FlappyBirdGame(),
      gameImage: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/logo/flappy_bird_logo.png')),
      gameRatio: Vector2(9, 16))
];

main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlameAudio.bgm.initialize();
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gameopolis',
      home: Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/logo/gameopolis_logo_line.png"))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 0.2,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(100), color: const Color(0xFF636363)),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(15),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _games.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  allowSnapshotting: false,
                                  builder: (_) => MainGame(
                                        game: _games[index].gameWidget,
                                        gameRatio: _games[index].gameRatio,
                                      )),
                              (route) => false),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: _games[index].gameImage,
                                color: Colors.black),
                            // child: Text(_games[index].gameName),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainGame extends StatelessWidget {
  const MainGame({required this.game, required this.gameRatio, super.key});

  final FlameGame game;
  final Vector2 gameRatio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ClipRect(
              child: AspectRatio(
                aspectRatio: gameRatio.x / gameRatio.y,
                child: GameWidget(
                  game: game,
                  loadingBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: BackButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false),
            ),
          ),
        ],
      ),
    );
  }
}
