import 'package:flutter/material.dart';

class FVCNavigatorMonitor extends NavigatorObserver {
  static final FVCNavigatorMonitor _instance = FVCNavigatorMonitor._();
  factory FVCNavigatorMonitor() => _instance;
  FVCNavigatorMonitor._();

  final Map<String, Function> _callbacks = {};

  onFocus(String pageName, Function callback) {
    _callbacks[pageName] = callback;
  }

  removeListener(String pageName) {
    if (_callbacks.containsKey(pageName)) {
      _callbacks.remove(pageName);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    String? current = previousRoute!.settings.name;
    String? previous = route.settings.name;

    if (_callbacks.containsKey(previous)) {
      _callbacks.remove(previous);
    }

    if (_callbacks.containsKey(current)) {
      _callbacks[current]!();
    }
  }
}
