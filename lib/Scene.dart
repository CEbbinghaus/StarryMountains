import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular_app/Libary/Vector.dart';
import 'package:angular_app/Particle.dart';

import 'Libary/GameObject.dart';
import 'Star.dart';
import 'Background.dart';

class Scene extends GameObject{
  Random rand = Random();
  List<Star> stars = [];

  Particles particles = Particles();

  Background background = Background();

  void OnAwake(){
    SpawnStar();
  }

  void SpawnStar(){
    final star = Star();
    star.position = Vector2(rand.nextDouble(), -100) * Vector2(window.innerWidth, 1);
    double offset = window.innerWidth / 2 - star.position.x;
    print((offset / window.innerWidth));
    star.velocity = Vector2(((rand.nextDouble() * 2) + -1) + (offset / (window.innerWidth / 2)), 1);
    stars.add(star);
    Timer(Duration(seconds: 1 + rand.nextInt(3)), SpawnStar);
  }

  void OnUpdate(){
    List<Star> tbd = [];
    stars.forEach((f){
      int todo = f.Update();
      if(todo == 2)
        tbd.add(f);
      if(todo == 1)
        particles.Spawn(f.position, rand.nextInt(4) + 8);
    });
    tbd.forEach((f){
      stars.remove(f);
    });
    particles.Update();
  }

  void OnRender(CanvasRenderingContext2D ctx){
    background.Render(ctx);
    ctx.save();
      ctx.shadowColor = "#fff";
      ctx.fillStyle = "#fff";
      ctx.shadowBlur = 10;
      stars.forEach((f){
        f.Render(ctx);
      });
      particles.Render(ctx);
    ctx.restore();
  }
}