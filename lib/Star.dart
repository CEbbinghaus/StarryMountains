import 'dart:html';
import 'dart:math';

import 'package:angular_app/Libary/Game.dart';
import 'package:angular_app/Libary/Time.dart';
import 'package:angular_app/Libary/Vector.dart';

class Star{
  Vector2 position = Vector2();
  Vector2 velocity = Vector2(0, .1);

  double speed = 200;
  double size = 20; 

  double gravity = 9.8;

  int Update(){
    velocity.y += gravity * Time.DeltaTime;

    int code = 0;

    if(position.y > window.innerHeight - 100 - size){
      position.y = (window.innerHeight - 100 - size).toDouble();
      velocity.y = -(velocity.y * 0.6);
      size -= 9;
      code = 1;
    }

    position += velocity * speed * Time.DeltaTime;
    if(size <= 0)
      code = 2;

    return code;
  }

  void Render(CanvasRenderingContext2D ctx){
    ctx.beginPath();
    ctx.arc(position.x, position.y, size, 0, pi * 2);
    ctx.fill();
  }
}