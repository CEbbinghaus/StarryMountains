import 'dart:html';
import 'dart:math';

import 'Vector.dart';

extension ContextExtention on CanvasRenderingContext2D{
  void fillRectV(Vector2 position, num width, num height) => this.fillRect(position.x, position.y, width, height);
  void fillRectC(Vector2 position, Vector2 size) => this.fillRect(position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
  void moveToV(Vector2 position) => this.moveTo(position.x, position.y);
  void arcV(Vector2 position, num radius, num startAngle, num endAngle) => this.arc(position.x, position.y, radius, startAngle, endAngle);
  void Circle(Vector2 position, num radius) => this.arcV(position, radius, 0, pi * 2);
}