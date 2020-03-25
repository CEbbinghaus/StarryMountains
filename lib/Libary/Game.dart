import 'dart:async';
import 'dart:html';
import 'Input.dart';
import 'Time.dart';
import '../main.dart';

class CursorData{
  double value;
  bool enabled = false;
}

enum Event{
  awake,
  start,
  earlyUpdate,
  fixedUpdate,
  update,
  lateUpdate,
  earlyRender,
  render,
  lateRender,
  gui,
  quit
}

class _GameUpdateEventEmitter{
  static StreamController<void> _awakeStream = StreamController.broadcast();
  static StreamController<void> _startStream = StreamController.broadcast();
  static StreamController<void> _earlyUpdateStream = StreamController.broadcast();
  static StreamController<void> _fixedUpdateStream = StreamController.broadcast();
  static StreamController<void> _updateStream = StreamController.broadcast();
  static StreamController<void> _lateUpdateStream = StreamController.broadcast();
  static StreamController<CanvasRenderingContext2D> _earlyRenderStream = StreamController.broadcast();
  static StreamController<CanvasRenderingContext2D> _renderStream = StreamController.broadcast();
  static StreamController<CanvasRenderingContext2D> _lateRenderStream = StreamController.broadcast();
  static StreamController<CanvasRenderingContext2D> _guiStream = StreamController.broadcast();
  static StreamController<CanvasRenderingContext2D> _quitStream = StreamController.broadcast();

  static dynamic _runCase(Event event, Function(dynamic) callback){
    switch(event){
      case Event.awake:
        return callback(_awakeStream);
        break;
      case Event.start:
        return callback(_startStream);
        break;
      case Event.earlyUpdate:
        return callback(_earlyUpdateStream);
        break;
      case Event.fixedUpdate:
        return callback(_fixedUpdateStream);
        break;
      case Event.update:
        return callback(_updateStream);
        break;
      case Event.lateUpdate:
        return callback(_lateUpdateStream);
        break;
      case Event.earlyRender:
        return callback(_earlyRenderStream);
        break;
      case Event.render:
        return callback(_renderStream);
        break;
      case Event.lateRender:
        return callback(_lateRenderStream);
        break;
      case Event.gui:
        return callback(_guiStream);
        break;
      case Event.quit:
        return callback(_quitStream);
        break;
    }
  }

  static StreamSubscription SetStream(Event e, dynamic t){
    var f = (dynamic) => t();
    return _runCase(e, (dynamic s){
      if(
        e == Event.earlyRender ||
        e == Event.render ||
        e == Event.lateRender ||
        e == Event.gui ||
        e == Event.quit
      ){
        return s.stream.listen(t);
      }else{
        return s.stream.listen(f);
      }
    });
  }

  static Emit(Event e, [dynamic v = null]){
    _runCase(e, (stream){
      stream.add(v);
    });
  }
}

class Game extends _GameUpdateEventEmitter{
  static Game Instance;

  static StreamSubscription _SetStream(Event e, dynamic t) => _GameUpdateEventEmitter.SetStream(e, t);
  static void _Emit(Event e, [dynamic t]) => _GameUpdateEventEmitter.Emit(e, t);

  static StreamSubscription OnAwake(Function f) => _SetStream(Event.awake, f);
  static StreamSubscription OnStart(Function f) => _SetStream(Event.start, f);
  static StreamSubscription OnEarlyUpdate(Function f) => _SetStream(Event.earlyUpdate, f);
  static StreamSubscription OnFixedUpdate(Function f) => _SetStream(Event.fixedUpdate, f);
  static StreamSubscription OnUpdate(Function f) => _SetStream(Event.update, f);
  static StreamSubscription OnLateUpdate(Function f) => _SetStream(Event.lateUpdate, f);
  static StreamSubscription OnEarlyRender(Function(CanvasRenderingContext2D) f) => _SetStream(Event.earlyRender, f);
  static StreamSubscription OnRender(Function(CanvasRenderingContext2D) f) => _SetStream(Event.render, f);
  static StreamSubscription OnLateRender(Function(CanvasRenderingContext2D) f) => _SetStream(Event.lateRender, f);
  static StreamSubscription OnGUI(Function(CanvasRenderingContext2D) f) => _SetStream(Event.gui, f);
  static StreamSubscription OnQuit(Function(CanvasRenderingContext2D) f) => _SetStream(Event.quit, f);

  int frame = 0;
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  CanvasElement guiCanvas;
  CanvasRenderingContext2D guiContext;

  bool isQuitting = false;

  Quit(){
    isQuitting = true;
  }

  Game(this.canvas, this.guiCanvas){
    this.context = canvas.getContext("2d");
    this.guiContext = guiCanvas.getContext("2d");
    Instance = this;

    Input.Initialize();

    try{
      main();
    }catch(E){};

    _Emit(Event.awake);
    _Emit(Event.start);
    window.requestAnimationFrame(Main);

    context.imageSmoothingEnabled = false;
    guiContext.imageSmoothingEnabled = false;
  }

  void Main(num time){
    Time.Update(time);
    frame++;
    _Emit(Event.earlyUpdate);
    _Emit(Event.fixedUpdate);
    _Emit(Event.update);
    _Emit(Event.lateUpdate);

    context.clearRect(0, 0, window.innerWidth, window.innerHeight);

    context.save();
    _Emit(Event.earlyRender, context);
    _Emit(Event.render, context);
    _Emit(Event.lateRender, context);
    context.restore();
    
    guiContext.clearRect(0, 0, window.innerWidth, window.innerHeight);
    guiContext.save();
    _Emit(Event.gui, guiContext);
    guiContext.restore();

    if(!isQuitting)
      window.requestAnimationFrame(Main);
    if(isQuitting){
      context.clearRect(0, 0, window.innerWidth, window.innerHeight);
      guiContext.clearRect(0, 0, window.innerWidth, window.innerHeight);
      _Emit(Event.quit, guiContext);
    }
  }
}

/*
   cursor = Cursor(context, draw: (ctx, pos, [data]){
      CursorData cdata = data as CursorData;

      if(Mouse.pressed){
        if(cdata.enabled)
          cdata.value += Time.DeltaTime;
      }else{
        cdata.value = 0;
        cdata.enabled = true;
      }


      ctx.beginPath();
      ctx.arc(pos.x, pos.y, 10, 0, pi * 2);
      ctx.fill();

      ctx.beginPath();
      ctx.moveTo(pos.x, pos.y);
      ctx.arc(pos.x, pos.y, 20, 0, (pi * 2) * cdata.value);
      ctx.fill();

      if(cdata.value > 1 && cdata.enabled){
        print("Click Occurred at ${pos.x}, ${pos.y}");
        cdata.enabled = false;
      }
    }, store: CursorData());
    */