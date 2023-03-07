import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:gameopolis/games/flappybird/game.dart';
import 'package:gameopolis/utils/utils.dart';

class TextUpdate extends TextComponent<TextRenderer> with HasGameRef<FlappyBirdGame> {
  TextUpdate(String text) : super(text: text);

  late final SpriteFontRenderer spriteFontRenderer;

  @override
  Future<void> onLoad() async {
    spriteFontRenderer = SpriteFontRenderer.fromFont(
      SpriteFont(
        source: gameRef.spriteImageFlappy,
        size: 18,
        ascent: 36,
        glyphs: [
          Glyph('0', left: 496.0, top: 60.0, width: 12.0),
          Glyph('1', left: 136.0, top: 455.0, width: 12.0),
          Glyph('2', left: 292.0, top: 160.0, width: 12.0),
          Glyph('3', left: 306.0, top: 160.0, width: 12.0),
          Glyph('4', left: 320.0, top: 160.0, width: 12.0),
          Glyph('5', left: 334.0, top: 160.0, width: 12.0),
          Glyph('6', left: 292.0, top: 184.0, width: 12.0),
          Glyph('7', left: 306.0, top: 184.0, width: 12.0),
          Glyph('8', left: 320.0, top: 184.0, width: 12.0),
          Glyph('9', left: 334.0, top: 184.0, width: 12.0),
          Glyph(' ', left: 0.0, top: 36.0, width: 12.0)
        ],
      ),
      letterSpacing: 0.0,
    );
    anchor = Anchor.center;
    textRenderer = spriteFontRenderer;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y * 0.1);
    scale = Vector2((gameRef.size.x / screenSize.width) - 1, (gameRef.size.x / screenSize.width) - 1);
  }

  void updateText(String text) {
    this.text = text;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y * 0.1);
    scale = Vector2((gameRef.size.x / screenSize.width) - 1, (gameRef.size.x / screenSize.width) - 1);
  }
}
