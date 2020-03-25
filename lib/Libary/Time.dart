class Time{
  static double _lastTime = 0;
  static double _deltaTime = 0;
  static double _oneTime = 0;
  static double _timeScale = 1;
  static double _unscaledDelta = 0;
  static double _totalTime = 0;
  static double _scaledTotal = 0;

  static double get DeltaTime => _deltaTime;
  static double get OneTime => _oneTime;
  static double get TimeScale => _timeScale;
  static void set TimeScale(double value){
    _timeScale = value;
  }
  static double get UnscaledDelta => _unscaledDelta;
  static double get TotalTime => _totalTime;
  static double get TotalScaled => _scaledTotal;

  static void Update(num currentTime){
    if(currentTime == null)return;

    num diff = (currentTime - _lastTime) / 1000;

    _unscaledDelta = diff;
    _totalTime += diff;

    _deltaTime = diff * _timeScale;
    _scaledTotal += diff * _timeScale;

    _oneTime = _deltaTime * 60;

    _lastTime = currentTime;
  }
}