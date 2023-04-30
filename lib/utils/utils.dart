// import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const screenSize = Size(144, 256);

const pi = 3.14159265359;

///     0 implies up/north direction
///  pi/2 implies right/east direction
///    pi implies down/south direction
/// -pi/2 implies left/west direction
const Map<String, double> direction = {
  'up': -pi / 2,
  'left': pi,
  'right': 0,
  'down': pi / 2,
};

class Tuple3<T1, T2, T3> {
  Tuple3({required T1 first, required T2 second, required T3 third})
      : _first = first,
        _second = second,
        _third = third,
        super();

  final T1 _first;
  final T2 _second;
  final T3 _third;

  T1 get first {
    return _first;
  }

  T2 get second {
    return _second;
  }

  T3 get third {
    return _third;
  }
}

class Tuple2<T1, T2> {
  Tuple2({required T1 first, required T2 second})
      : _first = first,
        _second = second,
        super();

  final T1 _first;
  final T2 _second;

  T1 get first {
    return _first;
  }

  T2 get second {
    return _second;
  }
}

class ShowGames {
  ShowGames(
      {required String gameName,
      DecorationImage? gameImage,
      required FlameGame gameWidget,
      required Vector2 gameRatio,
      Map<String, Widget Function(BuildContext, FlameGame)>? gameOverlays})
      : _gameName = gameName,
        _gameImage = gameImage,
        _gameWidget = gameWidget,
        _gameRatio = gameRatio,
        _map = gameOverlays,
        super();

  final String _gameName;
  final DecorationImage? _gameImage;
  final FlameGame _gameWidget;
  final Vector2 _gameRatio;
  final Map<String, Widget Function(BuildContext, FlameGame)>? _map;

  String get gameName {
    return _gameName;
  }

  DecorationImage? get gameImage {
    return _gameImage;
  }

  FlameGame get gameWidget {
    return _gameWidget;
  }

  Vector2 get gameRatio {
    return _gameRatio;
  }

  Map<String, Widget Function(BuildContext, FlameGame)>? get gameOverlays {
    return _map;
  }
}

final Paint paintCollision = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2;
