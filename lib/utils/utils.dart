import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const screenSize = Size(144, 256);

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
  ShowGames({required String gameName, DecorationImage? gameImage, required FlameGame gameWidget})
      : _gameName = gameName,
        _gameImage = gameImage,
        _gameWidget = gameWidget,
        super();

  final String _gameName;
  final DecorationImage? _gameImage;
  final FlameGame _gameWidget;

  String get gameName {
    return _gameName;
  }

  DecorationImage? get gameImage {
    return _gameImage;
  }

  FlameGame get gameWidget {
    return _gameWidget;
  }
}
