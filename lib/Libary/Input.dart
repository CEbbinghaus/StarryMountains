import 'dart:html';
import 'GameObject.dart';
import 'Game.dart';
import 'Time.dart';

import 'Vector.dart';

enum CursorType{
  Lock,
  Follow,
  None
}

class _Cursor extends GameObject{
  CanvasRenderingContext2D _ctx;

  dynamic storage;
  double timeDelay;

  CursorType _type;

  Vector2 _position = Vector2();
  Vector2 _size;


  void Function(CanvasRenderingContext2D, Vector2, [dynamic storage]) _drawFunction;

  _Cursor(CanvasRenderingContext2D context,{
    ImageElement data,
    void Function(CanvasRenderingContext2D, Vector2, dynamic) draw,
    CursorType type = CursorType.Lock,
    num secondsDelay = 0.1,
    Vector2 size,
    dynamic store
  }){

    if(context == null && data == null && draw == null)throw "Cursor Requires Context and Either Image data or Function to be Used for Drawing";
    _ctx = context;
    _size = size ?? null;
    _type = type;

    storage = store;

    timeDelay = secondsDelay;

    if(data != null)_drawFunction = (ctx, pos, [_]){
      if(_size == null)
        ctx.drawImage(data, pos.x, pos.y);
      else
        ctx.drawImageScaled(data, _position.x, _position.y, _size.x, _size.y);
    };

    if(draw != null)_drawFunction = draw;
  }
  
  void OnRender(CanvasRenderingContext2D ctx){

    switch(_type){
      case CursorType.Lock:
        _position = Mouse.position;
        break;
      case CursorType.Follow:
        _position += (Mouse.position - _position) * Time.DeltaTime / timeDelay;
        break;
      case CursorType.None:
    }
    _drawFunction?.call(_ctx, _position, storage);
  }

}

class Mouse extends GameObject{
  static Mouse _Instance;

  static Vector2 _position = Vector2();
  static Vector2 _delta = Vector2();

  static List<bool> _buttons = List<bool>.filled(MouseButton.Count.index, false);
  static List<bool> _pressed = List<bool>.filled(MouseButton.Count.index, false);
  static List<bool> _released = List<bool>.filled(MouseButton.Count.index, false);

  static double get x => _position.x;
  static double get y => _position.y;
  static double get dx => _delta.x;
  static double get dy => _delta.y;
  static Vector2 get position => _position;
  static Vector2 get delta => _delta;

  Mouse._();

  static Mouse Create(){
    Mouse._Instance ??= new Mouse._();

    window.onMouseMove.listen(_UpdateMousePosition);

    window.onMouseUp.listen((data) => _UpdateMouseButtons(false, data));
    window.onMouseDown.listen((data) => _UpdateMouseButtons(true, data));

    Game.OnLateUpdate(_Clear);

    return Mouse._Instance;
  }

  static void _Clear(){
    _delta = Vector2.zero;
    _pressed = List<bool>.filled(MouseButton.Count.index, false);
    _released = List<bool>.filled(MouseButton.Count.index, false);
  }

  static void _UpdateMouseButtons(bool state, MouseEvent evt){
    int button = evt.button;
    if(_buttons[button] && !state)_released[button] = true;
    if(!_buttons[button] && state)_pressed[button] = true;
    _buttons[button] = state;
  }

  static void _UpdateMousePosition(MouseEvent evt){
    _position = Vector2.fromPoint(evt.page);
    _delta = Vector2.fromPoint(evt.movement);
  }
}

class Keyboard extends GameObject{

	List<bool> _data = List<bool>.filled(256, false);

	static Keyboard Instance;

	void keyCallback(int state, KeyboardEvent evt) {
    if(_data[evt.keyCode] && state == 0){
      released[evt.keyCode] = true;
      anyUp = true;
    }else if(!_data[evt.keyCode] && state == 1){
      anyDown = true;
      pressed[evt.keyCode] = true;
    }

    _data[evt.keyCode] = state != 0;

    ctrlKey = evt.ctrlKey;
    shiftKey = evt.shiftKey;
    altKey = evt.altKey;
	}

	bool ctrlKey = false;
	bool shiftKey = false;
	bool altKey = false;

  bool anyDown = false;
  bool anyUp = false;

	List<bool> pressed = List<bool>.filled(256, false);
	List<bool> released = List<bool>.filled(256, false);

	void OnLateUpdate(){
    //print("Update called");
		if(Instance == null)return;

    anyUp = anyDown = false;

    pressed = List<bool>.filled(256, false);
    released = List<bool>.filled(256, false);
	}

	static Keyboard CreateKeyboard() {
		if (Instance != null)
			return Instance;

		Instance = Keyboard();

    window.onKeyUp.listen((evt) => Instance.keyCallback.call(0, evt));
    window.onKeyDown.listen((evt) => Instance.keyCallback.call(1, evt));
    window.onKeyPress.listen((evt) => Instance.keyCallback.call(2, evt));

		return Instance;
	}
}

class Input{
  static Input _instance = Input._();
  static Vector2 _directionVector = Vector2();

  Mouse mouse;
  Keyboard keyboard;

  Input._(){
    mouse = Mouse.Create();
    keyboard = Keyboard.CreateKeyboard();

    Game.OnEarlyUpdate(_UpdateData);
  }

  static void _UpdateData(){
    Vector2 input = Vector2();
    if(Input.GetKey(KeyCode.w)){
      input.y += -1;
    }
    if(Input.GetKey(KeyCode.s)){
      input.y += 1;
    }
    if(Input.GetKey(KeyCode.a)){
      input.x += -1;
    }
    if(Input.GetKey(KeyCode.d)){
      input.x += 1;
    }
    _directionVector = input;
  }

  static bool GetKeyDown(KeyCode key){
    return _instance.keyboard.pressed[key.Code];
  }

  static bool GetKeyUp(KeyCode key){
    return _instance.keyboard.released[key.Code];
  }

  static bool GetKey(KeyCode key){
    return _instance.keyboard._data[key.Code];
  }

  static Vector2 GetDirectionVector(){
    return _directionVector;
  }

  static bool GetMouseButtonDown(MouseButton button){
    return Mouse._pressed[button.index];
  }

  static bool GetMouseButtonUp(MouseButton button){
    return Mouse._released[button.index];
  }

  static bool GetMouseButton(MouseButton button){
    return Mouse._buttons[button.index];
  }

  static Vector2 GetMouseDelta(){
    return Mouse._delta;
  }

  static Vector2 GetMousePosition(){
    return Mouse._position;
  }

  static Input Initialize(){
    return _instance;
  }
}

enum MouseButton{
  Left,
  Middle,
  Right,
  Backward,
  Forward,
  Count
}

enum KeyCode {
    backspace,
    tab,
    enter,
    shift,
    ctrl,
    alt,
    pause,
    capslock,
    escape,
    pageUp,
    space,
    pageDown,
    end,
    home,
    arrowLeft,
    arrowUp,
    arrowRight,
    arrowDown,
    prtscrn,
    insert,
    delete,
    num0,
    num1,
    num2,
    num3,
    num4,
    num5,
    num6,
    num7,
    num8,
    num9,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
    t,
    u,
    v,
    w,
    x,
    y,
    z,
    lwindowKey,
    rwindowKey,
    selectKey,
    numpad0,
    numpad1,
    numpad2,
    numpad3,
    numpad4,
    numpad5,
    numpad6,
    numpad7,
    numpad8,
    numpad9,
    multiply,
    add,
    subtract,
    decimalpoint,
    divide,
    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f7,
    f8,
    f9,
    f10,
    f11,
    f12,
    numLock,
    scrollLock,
    myComputer,
    myCalculator,
    semicolon,
    equalsign,
    comma,
    dash,
    period,
    forwardSlash,
    openBracket,
    backSlash,
    closeBraket,
    singleQuote
}

extension KeyExtention on KeyCode{
  static List<int> codes = [8, 9, 13, 16, 17, 18, 19, 20, 27, 33, 32, 34, 35, 36, 37, 38, 39, 40, 44, 45, 46, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 144, 145, 182, 183, 186, 187, 188, 189, 190, 191, 219, 220, 221, 222];
  
  int get Code{
    return codes[this.index];
  }
}