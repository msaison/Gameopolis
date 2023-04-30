import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gameopolis/games/defenders/components/tourel/tourel.dart';
import 'package:gameopolis/games/defenders/game.dart';

TourelInfo? handleMouseClick(List<TourelInfo> squares, Vector2 mousePosition) {
  for (int i = 0; i < squares.length; i++) {
    Vector2 squareSize = squares[i].size;
    Vector2 squarePosition = squares[i].position;
    if (mousePosition.x >= squarePosition.x &&
        mousePosition.x <= squarePosition.x + squareSize.x &&
        mousePosition.y >= squarePosition.y &&
        mousePosition.y <= squarePosition.y + squareSize.y) {
      return squares[i];
    }
  }
  return null;
}

class TowerMenu extends StatefulWidget {
  const TowerMenu({Key? key, required this.game}) : super(key: key);

  final DefendersGame game;

  @override
  _TowerMenuState createState() => _TowerMenuState();
}

class _TowerMenuState extends State<TowerMenu> with TickerProviderStateMixin {
  static Duration duration = const Duration(milliseconds: 250);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          widget.game.overlays.remove('TowerMenu');
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    //_controller.reverse(from: 1.0);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        double animationVal = _controller.value;
        double translateVal = (animationVal - 1.0) * 320.0;
        return Transform.translate(
          offset: Offset(translateVal, 0.0),
          child: Drawer(
            backgroundColor: Colors.white24,
            child: ListView(children: <Widget>[
              DrawerHeader(
                padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 8.0),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[Text('PLATEFORME'), Text('Utilisé comme base pour les tours')],
                    ),
                    Text('Case : ${widget.game.tourel[widget.game.tourelSelect].number}')
                  ],
                ),
              ),
              ListTile(
                title: const Text('Buy'),
                onTap: () {
                  widget.game.tourel[widget.game.tourelSelect].setup(
                    damage_: 10,
                    vitesse_: 1.25,
                    srcSizeSkin_: Vector2(76, 92),
                    srcPosSkin_: Vector2(2458, 1042),
                  );
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () => _controller.reverse(),
              ),
            ]),
          ),
        );
      },
    );
  }
}
