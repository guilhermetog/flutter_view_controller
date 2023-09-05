import 'package:flutter/material.dart';

class Notifier<T> {
  late ValueNotifier<T> _notifier;
  final List<Function> _callbacks = [];
  List<Notifier<T>> _connectors = [];
  final List<NotifierTicker> _tickers = [];

  bool disposed = false;

  T get value => _notifier.value;

  int get connectors => _connectors.length;

  set value(T value) {
    if (disposed) {
      _notifier = ValueNotifier(value);
      disposed = false;
    }
    _notifier.value = value;
    for (var callback in _callbacks) {
      callback(_notifier.value);
    }

    for (var connector in _connectors) {
      connector.value = value;
    }

    for (var ticker in _tickers) {
      ticker.tick();
    }
  }

  Notifier(T value) {
    _notifier = ValueNotifier(value);
  }

  Widget show(Function(T) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: _notifier,
      builder: (_, value, __) => builder(value),
    );
  }

  listen(Function(T) callback) {
    _callbacks.add(callback);
  }

  connect(Notifier<T> connector) {
    if (_connectors.contains(connector)) return;
    _connectors.add(connector);
  }

  disconnect(Notifier<T> connector) {
    _connectors.remove(connector);
  }

  disconnectAll() {
    _connectors = [];
  }

  connectTicker(NotifierTicker ticker) {
    _tickers.add(ticker);
  }

  dispose() {
    _callbacks.clear();
    _connectors.clear();
    _notifier.dispose();
    disposed = true;
  }
}

class NotifierList<T> {
  late final ValueNotifier<List<T>> _notifier = ValueNotifier([]);
  final List<Function> _callbacks = [];
  final List<NotifierList<T>> _connectors = [];

  get length => _notifier.value.length;

  List<T> get value => _notifier.value;
  set value(List<T> value) {
    _notifier.value = value.toList();
    for (var callback in _callbacks) {
      callback(_notifier.value);
    }

    for (var connector in _connectors) {
      connector.value = value;
    }
  }

  Widget show(Function(List<T>) builder) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: _notifier,
      builder: (_, value, __) => builder(value),
    );
  }

  add(T object) {
    _notifier.value = [...(_notifier.value)..add(object)];
  }

  remove(T object) {
    final list = [...(_notifier.value)..remove(object)];
    _notifier.value = list;
  }

  clear() {
    _notifier.value = [];
  }

  listen(Function(List<T>) callback) {
    _callbacks.add(callback);
  }

  connect(NotifierList<T> connector) {
    _connectors.add(connector);
  }

  dispose() {
    _callbacks.clear();
    _connectors.clear();
    _notifier.dispose();
  }
}

class NotifierTicker {
  final ValueNotifier<bool> _notifier = ValueNotifier(false);
  final List<Function> _callbacks = [];
  final List<NotifierTicker> _connectors = [];

  tick() {
    _notifier.value = !_notifier.value;

    for (var callback in _callbacks) {
      callback();
    }

    for (var connector in _connectors) {
      connector.tick();
    }
  }

  listen(Function(List) callback) {
    _callbacks.add(callback);
  }

  connect(NotifierTicker connector) {
    _connectors.add(connector);
  }

  Widget show(Function builder) {
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (_, value, __) => builder(),
    );
  }

  dispose() {
    _callbacks.clear();
    _notifier.dispose();
  }
}
