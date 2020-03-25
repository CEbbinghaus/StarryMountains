
import 'GameObject.dart';
import 'Vector.dart';

class Transform{
  GameObject gameObject;
  Vector2 position = Vector2();
  Vector2 scale = Vector2.one;
  double rotaion = 0;

  Transform(this.gameObject);
}