class Plug<T> {
  Function callback = () async {};

  then(Function f) {
    callback = f;
  }

  get(Function(T) f) {
    callback = f;
  }

  call() async {
    await callback();
  }

  send(T arg) async {
    await callback(arg);
  }
}
