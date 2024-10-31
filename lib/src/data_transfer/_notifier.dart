import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// class Notifier<T> {
//   late final NotifierMonitor<T> _notifierMonitor = NotifierMonitor(_notifier);
//   late ValueNotifier<T> _notifier;
//   final List<Function> _callbacks = [];
//   final List<Notifier<T>> _connectors = [];
//   final List<NotifierTicker> _tickers = [];

//   bool disposed = false;

//   T get value => _notifier.value;

//   int get connectors => _connectors.length;

//   set value(T value) {
//     if (disposed) {
//       _notifier = ValueNotifier(value);
//       disposed = false;
//     }
//     _notifier.value = value;
//     for (var callback in _callbacks) {
//       callback(_notifier.value);
//     }

//     for (var connector in _connectors) {
//       connector.value = value;
//     }

//     for (var ticker in _tickers) {
//       ticker.tick();
//     }
//   }

//   Notifier(T value) {
//     _notifier = ValueNotifier(value);
//   }

//   Widget show(Function(T) builder) {
//     return _notifierMonitor.show(builder);
//   }

//   listen(Function(T) callback) {
//     _callbacks.add(callback);
//   }

//   unlisten(Function(T) callback) {
//     _callbacks.remove(callback);
//   }

//   connect(Notifier<T> connector) {
//     if (_connectors.contains(connector)) return;
//     _connectors.add(connector);
//   }

//   disconnect(Notifier<T> connector) {
//     _connectors.remove(connector);
//   }

//   disconnectAll() {
//     _connectors.clear();
//   }

//   connectTicker(NotifierTicker ticker) {
//     _tickers.add(ticker);
//   }

//   disconnectTicker(NotifierTicker ticker) {
//     _tickers.remove(ticker);
//   }

//   disconnectAllTickers() {
//     _tickers.clear();
//   }

//   dispose() {
//     _callbacks.clear();
//     _connectors.clear();
//     _notifier.dispose();
//     disposed = true;
//   }
// }

// class NotifierList<T> {
//   late final NotifierMonitor<List<T>> _notifiersMonitor = NotifierMonitor(_notifier);
//   late final ValueNotifier<List<T>> _notifier = ValueNotifier([]);
//   final List<Function> _callbacks = [];
//   final List<NotifierList<T>> _connectors = [];

//   get length => _notifier.value.length;

//   List<T> get value => _notifier.value;
//   set value(List<T> value) {
//     _notifier.value = value.toList();
//     for (var callback in _callbacks) {
//       callback(_notifier.value);
//     }

//     for (var connector in _connectors) {
//       connector.value = value;
//     }
//   }

//   Widget show(Function(List<T>) builder) {
//     return _notifiersMonitor.show(builder);
//   }

//   add(T object) {
//     _notifier.value = [...(_notifier.value)..add(object)];
//   }

//   remove(T object) {
//     final list = [...(_notifier.value)..remove(object)];
//     _notifier.value = list;
//   }

//   clear() {
//     _notifier.value = [];
//   }

//   update() {
//     value = [...value];
//   }

//   listen(Function(List<T>) callback) {
//     _callbacks.add(callback);
//   }

//   connect(NotifierList<T> connector) {
//     _connectors.add(connector);
//   }

//   dispose() {
//     _callbacks.clear();
//     _connectors.clear();
//     _notifier.dispose();
//   }
// }

// class NotifierTicker {
//   late final NotifierMonitor<bool> _notifierMonitor = NotifierMonitor(_notifier);
//   final ValueNotifier<bool> _notifier = ValueNotifier(false);
//   final List<Function> _callbacks = [];
//   final List<NotifierTicker> _connectors = [];

//   tick() {
//     _notifier.value = !_notifier.value;

//     for (var callback in _callbacks) {
//       callback();
//     }

//     for (var connector in _connectors) {
//       connector.tick();
//     }
//   }

//   listen(Function(List) callback) {
//     _callbacks.add(callback);
//   }

//   connect(NotifierTicker connector) {
//     _connectors.add(connector);
//   }

//   Widget show(Function builder) {
//     return _notifierMonitor.show((value) => builder());
//   }

//   dispose() {
//     _callbacks.clear();
//     _notifier.dispose();
//   }
// }

// class NotifierMonitor<T> {
//   final List<Function(T)> _builderCallbacks = [];
//   final ValueNotifier<T> _notifier;

//   NotifierMonitor(this._notifier);

//   Widget show(Function(T) builder) {
//     _builderCallbacks.add(builder);
//     return ValueListenableBuilder<T>(
//       valueListenable: _notifier,
//       builder: (context, value, child) {
//         return builder(value);
//       },
//     );
//   }
// }






























// class Notifiable<T> {
//   late T _value;
//   final ValueNotifier<bool> _ticker = ValueNotifier(false);
//   List<Function> _callbacks = [];

//   Notifiable(T value) : _value = value;

//   // Original listen method
//   listen(Function callback) {
//     _callbacks.add(callback);
//   }

//   // Notify all callbacks
//   notify() {
//     if (_callbacks.isNotEmpty) {
//       for (final callback in _callbacks) {
//         if (_value != null && callback is Function(T)) {
//           callback(_value);
//         } else {
//           callback();
//         }
//       }
//     }
//     _ticker.value = !_ticker.value;
//   }

//   addNotifier(Notifiable<T> notifier) {
//     if (notifier._callbacks.contains(notify)) return;
//     notifier.listen(notify);
//     return notifier;
//   }

//   removeNotifier(Notifiable notifier) {
//     notifier._callbacks.remove(notify);
//   }

//   clearNotifiers() {
//     _callbacks.clear();
//   }

//   // Widget builder to display the value
//   show(Widget Function(T) builder) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _ticker,
//       builder: (context, value, child) {
//         return builder(_value);
//       },
//     );
//   }
// }


// // Notifier class that inherits from Notifiable
// class Notifier<T> extends Notifiable<T> {
//   // Getter and setter for value with notify trigger
//   T get value => _value;
//   set value(T value) {
//     _value = value;
//     notify();
//   }

//   // Constructor passing value to the parent
//   Notifier(T value) : super(value);

//   factory Notifier.withType(T type, dynamic value) {
//     return Notifier<T>(value as T);
//   }
// }

// class NotifierGroup extends Notifiable {
//   final Notifier<List<Notifiable>> _notifiers = Notifier([]);

//   NotifierGroup(List<Notifier> notifiers) : super(null) {
//     addAll(notifiers);
//   }

//   addAll(List<Notifiable> notifiers) {
//     for (var notifiable in notifiers) {
//       addNotifier(notifiable);
//     }
//     super.addNotifier(_notifiers);
//   }

//   @override
//   addNotifier(Notifiable notifier) {
//     if (_notifiers.value.contains(notifier)) return;
//     _notifiers.value.add(notifier);
//     return notifier;
//   }

//   @override
//   removeNotifier(Notifiable notifier) {
//     _notifiers.value.remove(notifier);
//   }
// }
