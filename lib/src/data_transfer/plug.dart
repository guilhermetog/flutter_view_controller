class Plug<T> {
  Function callback = () async {};
  bool _isConnected = false;

  then(Function() f) {
    _isConnected = true;
    callback = f;
  }

  take(Function(T) f) {
    _isConnected = true;
    callback = f;
  }

  call() async {
    if (!_isConnected) return;
    await callback();
  }

  send(T arg) async {
    if (!_isConnected) return;
    await callback(arg);
  }
}
