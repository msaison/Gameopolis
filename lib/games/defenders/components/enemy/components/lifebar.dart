import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LifeBar extends PositionComponent {
  static const double _barWidth = 50;
  static const double _barHeight = 5;
  static const double _borderRadius = 5;

  final double maxLife;
  double currentLife;

  LifeBar(this.maxLife, {this.currentLife = 0}) : super(anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x,
          y,
          _barWidth,
          _barHeight,
        ),
        const Radius.circular(_borderRadius),
      ),
      Paint()..color = Colors.white,
    );

    // Draw the current life
    final currentWidth = currentLife / maxLife * _barWidth;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x,
          y,
          currentWidth,
          _barHeight,
        ),
        const Radius.circular(_borderRadius),
      ),
      Paint()..color = Colors.red,
    );
  }

  void updateLife(double newLife) {
    currentLife = newLife;
  }
}
