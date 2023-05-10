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
  final ScreenSize size = ScreenSize();
  final T controller;
  View({required this.controller}) : super(key: controller.key);
  Widget build(BuildContext context);

  withSize({double? height, double? width}) {
    size.defineHeight(height);
    size.defineWidth(width);
  }

  double height(double percentage) => size.viewHeight(percentage);
  double width(double percentage) => size.viewWidth(percentage);
  double screenHeight(double percentage) => size.height(percentage);
  double screenWidth(double percentage) => size.width(percentage);

  @override
  State<StatefulWidget> createState() {
    return _ViewState<T>();
  }
}

class _ViewState<T extends Controller> extends State<View<T>> {
  late T controller;
  bool contextInitialized = false;

  @override
  initState() {
    controller = widget.controller;
    if (!controller._isInitialized) {
      controller.onInit();
      controller._isInitialized = true;
      GlobalState._connect(controller._refresh);
    } else {
      controller.onUpdate();
    }
    super.initState();
  }

  _initializeContext(BuildContext context) {
    if (!contextInitialized) {
      widget.size.calculateSizes(context);
      controller.context = context;
      contextInitialized = true;
    }
  }

  @override
  dispose() {
    controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializeContext(context);
    return controller._refresh.show(() {
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
