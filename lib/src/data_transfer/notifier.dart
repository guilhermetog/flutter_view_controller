import 'package:flutter/material.dart';

class Notifier<T> {
  T _value;
  final List<Function> _callbacks = [];
  final ValueNotifier<bool> _ticker = ValueNotifier(false);

  Notifier(this._value);

  // Add a listener to the callbacks list
  void listen(Function callback) {
    _callbacks.add(callback);
  }

  // Notify all listeners
  void notify() {
    for (final callback in _callbacks) {
      if (_value != null && callback is Function(T)) {
        callback(_value);
      } else {
        callback();
      }
    }
    _ticker.value = !_ticker.value;
  }

  List<Notifier> addAllNotifiers(List<Notifier> notifiers) {
    for (final notifier in notifiers) {
      addNotifier(notifier);
    }
    return notifiers;
  }

  // Allows adding another Notifier to listen for its changes
  Notifier<Y> addNotifier<Y>(Notifier<Y> notifier) {
    if (!notifier._callbacks.contains(notify)) {
      notifier.listen(notify);
    }

    return notifier;
  }

  // Removes a notifier's listener
  void removeNotifier(Notifier notifier) {
    notifier._callbacks.remove(notify);
  }

  // Clear all listeners
  void clearNotifiers() {
    _callbacks.clear();
  }

  // Display the value using a widget builder
  Widget show(Widget Function(T) builder) {
    return ValueListenableBuilder<bool>(
      valueListenable: _ticker,
      builder: (context, value, child) {
        return builder(_value);
      },
    );
  }

  // Getter and setter for the value
  T get value => _value;
  set value(T newValue) {
    _value = newValue;
    notify();
  }

  T call([T? newValue]) {
    if (newValue != null) {
      _value = newValue;
      notify();
    }
    return _value;
  }
}

class NotifierView<T> extends StatelessWidget {
  final Notifier<T> notifier;
  final Widget Function(T) builder;

  // ignore: use_key_in_widget_constructors
  const NotifierView({required this.notifier, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier._ticker,
      builder: (context, value, child) {
        return builder(notifier.value);
      },
    );
  }
}
