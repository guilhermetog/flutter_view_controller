import 'package:flutter_view_controller/src/notifier.dart';

class GlobalState<T> {
  static final Map<Type, Notifier> _states = {};
  T get current => GlobalState._states[T]!.value;
  set current(T value) => GlobalState._states[T]!.value = value;

  register(T value) => GlobalState._states[T] = Notifier(value);
}
