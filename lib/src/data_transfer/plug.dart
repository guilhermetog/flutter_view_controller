class Plug<T> {
  Function callback = () async {};
  bool isConnected = false;

  then(Function() f) {
    isConnected = true;
    callback = f;
  }

  take(Function(T) f) {
    isConnected = true;
    callback = f;
  }

  call() async {
    if (!isConnected) return;
    await callback();
  }

  send(T arg) async {
    if (!isConnected) return;
    await callback(arg);
  }
}
