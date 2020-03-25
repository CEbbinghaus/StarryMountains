import 'dart:html';
import 'dart:math';

import 'package:angular_app/Libary/Time.dart';
import 'package:angular_app/Libary/Vector.dart';

class Particle{
  double _startLifetime;
  Vector2 position = Vector2();
  Vector2 velocity = Vector2();
  double size = 2;
  double get opacity{
    return lifetime / _startLifetime;
  }
  double lifetime = 5;

  Particle({this.lifetime = 5, this.position, this.velocity, this.size = 5}){
    _startLifetime = lifetime;
  }
}

class Particles{
  Random rand = Random();
  List<Particle> active = [];

  void Spawn(Vector2 position, int amount){
    for(int i = 0; i < amount; ++i){
      active.add(Particle(
        position: position,
        lifetime: rand.nextDouble() * 4,
        velocity: Vector2((1 - (rand.nextDouble() * 1.5)) * 2, -3.5 + rand.nextDouble()) * 100
      ));
    }
  }

  void Update(){
    try{
      List<Particle> tbd = [];
      active.forEach((p){
        p.velocity.y += 980 * Time.DeltaTime;
        p.position += p.velocity * Time.DeltaTime;

        if(p.position.y > window.innerHeight - 100 - p.size){
          p.position.y = window.innerHeight - 100 - p.size;
          p.velocity *= -Vector2.up + Vector2.right;
        }

        p.lifetime -= Time.DeltaTime;
        if(p.lifetime <= 0)
          tbd.add(p);
      });
      tbd.forEach((p){
        active.remove(p);
      });
    }catch(ext){
      print(ext);
    }
  }

  void Render(CanvasRenderingContext2D ctx){
    active.forEach((p){
      ctx.fillStyle = "rgba(255, 255, 255, ${p.opacity})";
      ctx.beginPath();
      ctx.arc(p.position.x, p.position.y, p.size, 0, pi * 2);
      ctx.fill();
    });
  }
}