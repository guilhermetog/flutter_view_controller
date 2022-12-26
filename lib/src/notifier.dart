import 'package:flutter/material.dart';

class Notifier<T> {
  late ValueNotifier<T> notifier;
  List<Function> callbacks = [];
  bool disposed = false;

  T get value => notifier.value;
  set value(T value) {
    if (disposed) {
      notifier = ValueNotifier(value);
      disposed = false;
    }
    notifier.value = value;
    for (var callback in callbacks) {
      callback(notifier.value);
    }
  }

  Notifier(T value) {
    notifier = ValueNotifier(value);
  }

  Widget show(Function(T) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (_, value, __) => builder(value),
    );
  }

  listen(Function(T) callback) {
    callbacks.add(callback);
  }

  dispose() {
    callbacks = [];
    notifier.dispose();
    disposed = true;
  }
}

class NotifierList<T> {
  late ValueNotifier<List<T>> notifier = ValueNotifier([]);
  List<Function> callbacks = [];

  get length => notifier.value.length;

  List<T> get value => notifier.value;
  set value(List<T> value) {
    notifier.value = value.toList();
    for (var callback in callbacks) {
      callback(notifier.value);
    }
  }

  Widget show(Function(List<T>) builder) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: notifier,
      builder: (_, value, __) => builder(value),
    );
  }

  add(T object) {
    notifier.value = [...(notifier.value)..add(object)];
  }

  remove(T object) {
    final list = [...(notifier.value)..remove(object)];
    notifier.value = list;
  }

  clear() {
    notifier.value = [];
  }

  listen(Function(List<T>) callback) {
    callbacks.add(callback);
  }

  dispose() {
    callbacks = [];
    notifier.dispose();
    notifier = ValueNotifier<List<T>>([]);
  }
}

class NotifierTicker {
  ValueNotifier<bool> notifier = ValueNotifier(false);
  List<Function> callbacks = [];

  tick() {
    notifier.value = !notifier.value;
    for (var callback in callbacks) {
      callback(notifier.value);
    }
  }

  listen(Function(List) callback) {
    callbacks.add(callback);
  }

  Widget show(Function builder) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, value, __) => builder(),
    );
  }

  dispose() {
    callbacks = [];
    notifier.dispose();
  }
}
