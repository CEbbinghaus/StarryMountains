import 'dart:html';
import 'dart:math';
import 'Vector.dart';

class Icon{
  Vector2 size;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  
  ImageData data;

  ImageElement sprite;

  Icon(this.sprite, {this.canvas, this.size}){
    this.canvas ??= document.createElement("canvas");
    canvas.style.display = "hidden";
    size ??= Vector2(sprite.width, sprite.height);
    canvas.width = size.x.ceil();
    canvas.height = size.y.ceil();
    ctx = canvas.getContext("2d");
  }

  ImageData DrawRotatedPercentage(double amount){
    double radius = size.Magnitude / 2;
    ctx.save();
      double radians = (1.5 + (amount * 2)) * pi;
      ctx.drawImageScaled(sprite, 0, 0, size.x, size.y);
      ctx.globalCompositeOperation = "destination-in";
      ctx.beginPath();
      ctx.moveTo(size.x / 2, size.y / 2);
      ctx.arc(size.x / 2, size.y / 2, radius, pi * 1.5, radians);
      ctx.fill();
    ctx.restore();
    return data = ctx.getImageData(0, 0, size.x.toInt(), size.y.toInt());
  }
}