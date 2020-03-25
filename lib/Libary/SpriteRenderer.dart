
import 'dart:html';
import 'dart:math';

import 'Vector.dart';



class SpriteRender{
  ImageElement e;
  Vector2 SpriteSize;

  Vector2 ImageSize;

  Vector2 SpriteCount;

  SpriteRender(this.e, this.SpriteSize){
    ImageSize = Vector2(e.width, e.height);
    SpriteCount = Vector2((ImageSize.x / SpriteSize.x).floor(), (ImageSize.y / SpriteSize.y).floor());
  }

  DrawSprite(CanvasRenderingContext2D ctx, Vector2 position, int index, {Vector2 size}){
    size ??= SpriteSize;
    int xIndex = (index % SpriteCount.x).toInt();
    int yIndex = (index / SpriteCount.x).floor();

    Rectangle<num> source = Rectangle<num>(xIndex * SpriteSize.x, yIndex * SpriteSize.y, SpriteSize.x, SpriteSize.y);
    Rectangle<num> dest = Rectangle<num>(position.x, position.y, size.x, size.y);

    ctx.drawImageScaledFromSource(e, xIndex * SpriteSize.x, yIndex * SpriteSize.y, SpriteSize.x, SpriteSize.y, position.x, position.y, size.x, size.y);
    //ctx.drawImageToRect(e, dest, sourceRect: source);
  }
}