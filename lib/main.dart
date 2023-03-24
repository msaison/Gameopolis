import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/games/runner/runner_game.dart';
import 'package:gameopolis/utils/utils.dart';

List<ShowGames> _games = [
  ShowGames(
      gameName: 'Runner',
      gameImage: const DecorationImage(image: AssetImage('assets/logo/t_rex_logo.png')),
      gameWidget: RunnerGame()),
  ShowGames(
      gameName: 'Flappy Bird',
      gameWidget: FlappyBirdGame(),
      gameImage: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/logo/flappy_bird_logo.png')))
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
        body: Padding(
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: const Color(0xFF636363)),
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
                    // mainAxisExtent: 256,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              allowSnapshotting: false,
                              builder: (_) => MainGame(
                                    game: _games[index].gameWidget,
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
    );
  }
}

class MainGame extends StatelessWidget {
  const MainGame({required this.game, super.key});

  final FlameGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRect(
            child: AspectRatio(
              aspectRatio: 9/16,
              child: GameWidget(
                game: game,
                loadingBuilder: (_) => const Center(
                  child: CircularProgressIndicator(),
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
