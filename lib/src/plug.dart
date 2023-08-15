class Plug<T> {
  Function callback = () async {};
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  then(Function f) {
    _isConnected = true;
    callback = f;
  }

  get(Function(T) f) {
    _isConnected = true;
    callback = f;
  }

  call() async {
    await callback();
  }

  send(T arg) async {
    await callback(arg);
  }
}
