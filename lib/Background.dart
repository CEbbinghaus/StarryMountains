import 'dart:html';
import 'dart:math';

import 'package:angular_app/Colors.dart';
import 'package:angular_app/Libary/Vector.dart';

class star{
  static Random rand = Random();
  Vector2 position = Vector2();
  num size = 1;
  num bloom = 5;

  star({this.position, this.size});


  void Render(CanvasRenderingContext2D ctx){
    bloom = min(bloom + (1 - rand.nextDouble() * 2) * 2, size * 10);
    ctx.shadowBlur = 5 + bloom;

    ctx.beginPath();
    ctx.arc(position.x, position.y, size, 0, pi * 2);
    ctx.fill();
  }
}

class Background{

  List<star> stars = [];

  Background(){
    int amount = (window.innerHeight + window.innerWidth) ~/ 10;
    for(int i = 0; i < amount; ++i){
      stars.add(star(
        position: Vector2.InRect(window.innerWidth, window.innerHeight),
        size: star.rand.nextDouble() * 5
      ));
    }
  }

  void DrawMountains(CanvasRenderingContext2D ctx, num height, int amount, [num floor = 100]){
    ctx.beginPath();
    double splitWidth = window.innerWidth / amount;

    for(int i = 0; i < amount; ++i){
      ctx.moveTo(i * splitWidth, window.innerHeight - floor);
      ctx.lineTo(i * splitWidth + splitWidth / 2,  (window.innerHeight - floor) - height);
      ctx.lineTo((i + 1) * splitWidth, window.innerHeight - floor);
    }
    ctx.lineTo(0, window.innerHeight - floor);
    ctx.fill();
  }

  void Render(CanvasRenderingContext2D ctx){
    var gradient = ctx.createLinearGradient(window.innerWidth / 2, 0, window.innerWidth / 2, window.innerHeight);
    gradient.addColorStop(0, Colors.End);
    gradient.addColorStop(1, Colors.Deep);
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, window.innerWidth, window.innerHeight);
    
    
    ctx.fillStyle = ctx.shadowColor = "#fff";
    stars.forEach((s){
      s.Render(ctx);
    });
    ctx.save();
      ctx.shadowBlur = 20;
      ctx.shadowColor = ctx.fillStyle = Colors.Deep;
      DrawMountains(ctx, min(window.innerHeight * 0.7, 800.0), 1, 100);
      ctx.shadowColor = ctx.fillStyle = Colors.Mid;
      DrawMountains(ctx, min(window.innerHeight * 0.5, 500.0), 2, 100);
      ctx.shadowColor = ctx.fillStyle = Colors.Follow;
      DrawMountains(ctx, min(window.innerHeight * 0.3, 300.0), 4, 100);

      ctx.shadowColor = ctx.fillStyle = Colors.Lead;
      ctx.shadowBlur = 10;
      ctx.fillRect(0, window.innerHeight - 100, window.innerWidth, 100);
    ctx.restore();
  }
}