import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

import 'navigator_monitor.dart';
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

typedef ViewOf<T extends Controller> = View<T>;

abstract class View<T extends Controller> extends StatefulWidget {
  final ScreenSize size = ScreenSize();
  late final ControllerBox<T> _controllerBox;

  T get controller => _controllerBox.controller!;
  double get safeArea => size.paddingTop;

  View({required T controller}) : super(key: controller.key) {
    controller._setNavigatorMonitor(runtimeType.toString());
    _controllerBox = ControllerBox();
    _controllerBox.update(controller);
  }

  Widget build(BuildContext context);

  withSize({double? height, double? width}) {
    size.defineHeight(height);
    size.defineWidth(width);
  }

  double height(double percentage) => size.viewHeight(percentage);
  double width(double percentage) => size.viewWidth(percentage);
  double screenHeight(double percentage) => size.height(percentage);
  double screenWidth(double percentage) => size.width(percentage);
  double safeHeight(double percentage) => size.safeHeight(percentage);

  @override
  State<StatefulWidget> createState() {
    return _ViewState<T>();
  }
}

class _ViewState<T extends Controller> extends State<View<T>> {
  T? controller;
  bool controllerInitialized = false;

  @override
  initState() {
    _initializeController();
    if (!controllerInitialized) {
      controller!.onInit();
      GlobalState._connect(controller!._refresh);
      controllerInitialized = true;
    }
    super.initState();
  }

  _initializeController() {
    if (controller == null || controller!.key != widget.controller.key) {
      controller = widget.controller;
    } else {
      widget._controllerBox.update(controller!);
    }
  }

  _initializeContext(BuildContext context) {
    widget.size.calculateSizes(context);
    controller!.context = context;
    controller!.onContext(context);
  }

  @override
  dispose() {
    controller!._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializeController();
    _initializeContext(context);
    return controller!._refresh.show(() {
      return widget.build(context);
    });
  }
}

class ControllerBox<T> {
  T? controller;

  update(T controller) {
    this.controller = controller;
  }
}

abstract class Controller {
  static final Map<Type, Controller> _controllers = {};
  static T register<T extends Controller>(T controller) {
    if (_controllers.containsKey(T)) {
      return _controllers[T] as T;
    } else {
      _controllers[T] = controller;
      return controller;
    }
  }

  GlobalKey key = GlobalKey();
  final NotifierTicker _refresh = NotifierTicker();
  BuildContext? context;
  late String viewType;

  _setNavigatorMonitor(String view) {
    viewType = view;
    FVCNavigatorMonitor().onFocus(viewType, onUpdate);
  }

  onInit();
  onContext(BuildContext context) {}
  onUpdate() {}
  onClose();

  _dispose() {
    if (_controllers.containsKey(runtimeType)) {
      _controllers.remove(runtimeType);
    }
    FVCNavigatorMonitor().removeListener(viewType);
    onClose();
  }

  refresh() {
    onClose();
    onInit();
    _refresh.tick();
  }
}
