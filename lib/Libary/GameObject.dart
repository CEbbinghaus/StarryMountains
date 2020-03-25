import 'dart:async';

import 'Game.dart';
import 'Transform.dart';
import 'dart:html';

class GameObject{
  Transform transform;

  StreamSubscription _AwakeSubscription;
  StreamSubscription _StartSubscription;
  StreamSubscription _EarlyUpdateSubscription;
  StreamSubscription _FixedUpdateSubscription;
  StreamSubscription _UpdateSubscription;
  StreamSubscription _LateUpdateSubscription;
  StreamSubscription _EarlyRenderSubscription;
  StreamSubscription _RenderSubscription;
  StreamSubscription _LateRenderSubscription;
  StreamSubscription _GUISubscription;
  StreamSubscription _QuitSubscription;
  
  bool Active = true;

  static destroy(GameObject obj){
    if(obj._AwakeSubscription != null)obj._AwakeSubscription.cancel();
    if(obj._StartSubscription != null)obj._StartSubscription.cancel();
    if(obj._EarlyUpdateSubscription != null)obj._EarlyUpdateSubscription.cancel();
    if(obj._FixedUpdateSubscription != null)obj._FixedUpdateSubscription.cancel();
    if(obj._UpdateSubscription != null)obj._UpdateSubscription.cancel();
    if(obj._LateUpdateSubscription != null)obj._LateUpdateSubscription.cancel();
    if(obj._EarlyRenderSubscription != null)obj._EarlyRenderSubscription.cancel();
    if(obj._RenderSubscription != null)obj._RenderSubscription.cancel();
    if(obj._LateRenderSubscription != null)obj._LateRenderSubscription.cancel();
    if(obj._GUISubscription != null)obj._GUISubscription.cancel();
    if(obj._QuitSubscription != null)obj._QuitSubscription.cancel();
  }

  GameObject(){
    transform = Transform(this);
    dynamic d = this;
    if(d.OnAwake != null)_AwakeSubscription = Game.OnAwake(_Wrap(d.OnAwake));
    if(d.OnStart != null)_StartSubscription = Game.OnStart(_Wrap(d.OnStart));
    if(d.OnEarlyUpdate != null)_EarlyUpdateSubscription = Game.OnEarlyUpdate(_Wrap(d.OnEarlyUpdate));
    if(d.OnFixedUpdate != null)_FixedUpdateSubscription = Game.OnFixedUpdate(_Wrap(d.OnFixedUpdate));
    if(d.OnUpdate != null)_UpdateSubscription = Game.OnUpdate(_Wrap(d.OnUpdate));
    if(d.OnLateUpdate != null)_LateUpdateSubscription = Game.OnLateUpdate(_Wrap(d.OnLateUpdate));
    if(d.OnEarlyRender != null)_EarlyRenderSubscription = Game.OnEarlyRender(_Wrap(d.OnEarlyRender));
    if(d.OnRender != null)_RenderSubscription = Game.OnRender(_Wrap(d.OnRender));
    if(d.OnLateRender != null)_LateRenderSubscription = Game.OnLateRender(_Wrap(d.OnLateRender));
    if(d.OnGUI != null)_GUISubscription = Game.OnGUI(_Wrap(d.OnGUI));
    if(d.OnQuit != null)_QuitSubscription = Game.OnQuit(_Wrap(d.OnQuit));
  }

  dynamic _Wrap(dynamic func){
    var v = ([dynamic v]){
      try{
        if(Active)v == null ?func() : func(v);
      }catch(identifier){
        destroy(this);
        throw identifier;
      }
    };
    //print("$func||$v");
    return v;
  }

  void OnAwake(){}
  void OnStart(){}
  void OnEarlyUpdate(){}
  void OnFixedUpdate(){}
  void OnUpdate(){}
  void OnLateUpdate(){}
  void OnEarlyRender(CanvasRenderingContext2D ctx){}
  void OnRender(CanvasRenderingContext2D ctx){}
  void OnLateRender(CanvasRenderingContext2D ctx){}
  void OnGUI(CanvasRenderingContext2D ctx){}
  void OnQuit(CanvasRenderingContext2D ctx){}

  @override
  noSuchMethod(Invocation invocation) {
    return null;
  }
} 