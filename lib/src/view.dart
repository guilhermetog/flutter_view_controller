import 'package:flutter/material.dart';
import 'notifier.dart';
import 'screen_size.dart';

class GlobalState<T> {
  static final Map<Type, Notifier> _states = {};
  T get current => GlobalState._states[T]!.value;
  set current(T value) => GlobalState._states[T]!.value = value;

  register(T value) => GlobalState._states[T] = Notifier(value);
  static void _connect(NotifierTicker ticker) {
    for (final state in _states.values) {
      state.connectTicker(ticker);
    }
  }
}

abstract class View<T extends Controller> extends StatefulWidget {
  late final ScreenSize size;
  final T controller;
  View({required this.controller}) : super(key: controller.key);
  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    return _ViewState<T>();
  }
}

class _ViewState<T extends Controller> extends State<View<T>> {
  late T controller;

  @override
  initState() {
    super.initState();
    controller = widget.controller;
    if (!controller._isInitialized) {
      controller.onInit();
      controller._isInitialized = true;
      GlobalState._connect(controller._refresh);
    } else {
      controller.onUpdate();
    }
  }

  @override
  dispose() {
    controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.size = ScreenSize(context);
    return controller._refresh.show(() {
      controller.context = context;
      return widget.build(context);
    });
  }
}

abstract class Controller {
  GlobalKey key = GlobalKey();
  bool _isInitialized = false;
  final NotifierTicker _refresh = NotifierTicker();
  BuildContext? context;

  onInit();
  onUpdate() {}
  onClose();

  _dispose() {
    onClose();
  }

  changeTheme() {}

  refresh() {
    onClose();
    onInit();
    _refresh.tick();
  }
}
