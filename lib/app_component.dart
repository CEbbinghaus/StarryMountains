import 'dart:html';
import 'package:angular/angular.dart';
import './Libary/Game.dart';

@Component(
  selector: 'my-app',
  styles: ["canvas: {position: absolute; top: 0px; left: 0px;}"],
  template: '<canvas id="GameCanvas" [style.background-color]="\'#3f5f87\'"></canvas><canvas id="GuiCanvas"></canvas>'
)
class AppComponent implements OnInit {
  CanvasElement canvas;
  CanvasElement guiCanvas;

  Game game;

  @override
  void ngOnInit() {
    canvas = querySelector("#GameCanvas");
    guiCanvas = querySelector("#GuiCanvas");

    if(canvas == null || guiCanvas == null)
      throw "Canvas Could not be Found";

    guiCanvas.width = canvas.width = window.innerWidth;
    guiCanvas.height = canvas.height = window.innerHeight;

    window.onResize.listen((Event){
      guiCanvas.width = canvas.width = window.innerWidth;
      guiCanvas.height = canvas.height = window.innerHeight;
    });
    
    game = new Game(canvas, guiCanvas);
  }
}
