import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' show Paint, Colors, PaintingStyle;
import 'package:gameopolis/games/defenders/components/enemy/components/enemy.dart';
import 'package:gameopolis/games/defenders/components/tourel/tourel.dart';
import 'package:gameopolis/games/defenders/components/utils_defenders.dart';
// ignore: implementation_imports
import 'package:gameopolis/utils/utils.dart';

import 'components/enemy/enemy_main.dart';

Vector2 tilesSize = Vector2(1280, 736);

class DefendersGame extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection, HasGameRef<DefendersGame> {
  late final Image spriteImage;
  late RectangleComponent _selectedTourelShow;
  late final Vector2 spawnEnemy;
  final TourelManager _tourelManager = TourelManager();
  List<Tuple2<Vector2, String>> pathPos = [];
  List<TourelInfo> tourel = [];
  final EnemyMain enemy = EnemyMain(100, EnemyState.fantassin);
  Vector2 _scale = Vector2(0, 0);
  int tourelSelect = 0;

  Vector2 get scale => _scale;
  double get life => enemy.life;

  @override
  FutureOr<void> onLoad() async {
    var paintTourelSelect = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    _scale = Vector2((gameRef.size.x / tilesSize.x), (gameRef.size.y / tilesSize.y));
    spriteImage = await Flame.images.load('tiles/towerDefense_tilesheet@2.png');
    _selectedTourelShow = RectangleComponent()
      ..paint = paintTourelSelect
      ..renderShape = true;

    final level = await TiledComponent.load('map.tmx', Vector2(32, 32));
    final component = TiledComponent(level.tileMap, scale: Vector2(_scale.x, _scale.y));
    final spawnpoint = component.tileMap.getLayer<ObjectGroup>('object');

    for (final object in spawnpoint!.objects) {
      if (object.class_.substring(0, 4) == 'path') {
        pathPos.insert(
            int.parse(object.class_.substring(5)),
            Tuple2(
                first: Vector2(object.x * _scale.x, object.y * _scale.y),
                second: object.properties.first.value.toString()));
      }
      if (object.class_.substring(0, 6) == 'tourel') {
        tourel.add(TourelInfo(
            position: Vector2(object.x * _scale.x, object.y * _scale.y),
            size: Vector2(object.width * _scale.x, object.height * _scale.y),
            number: int.parse(object.class_.substring(7)),
            spriteImage: spriteImage));
      }

      switch (object.class_) {
        case 'spawn_point':
          spawnEnemy = Vector2((object.x + object.width / 2) * _scale.x, object.y * _scale.y);
          break;
        default:
      }
    }

    add(component);
    add(_selectedTourelShow);
    add(_tourelManager);
    add(enemy);
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    TourelInfo? info_ = handleMouseClick(tourel, info.eventPosition.game);
    if (info_ != null) {
      overlays.remove('TowerMenu');
      _selectedTourelShow.size = info_.size;
      _selectedTourelShow.position = info_.position;
      tourelSelect = tourel.indexOf(info_);
      overlays.add('TowerMenu');
    } else {
      overlays.remove('TowerMenu');
      _selectedTourelShow.size = Vector2(0, 0);
    }
    super.onTapDown(info);
  }
}
