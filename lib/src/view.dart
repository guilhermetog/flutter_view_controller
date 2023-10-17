import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

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
  late final ScreenSize size;
  late final ControllerBox<T> _controllerBox;

  T get controller => _controllerBox.controller!;

  View({required T controller, ScreenSize? size}) : super(key: controller.key) {
    this.size = size ?? ScreenSize.empty();
    controller._setNavigatorMonitor(runtimeType.toString());
    _controllerBox = ControllerBox();
    _controllerBox.update(controller);
  }

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    return _ViewState<T>();
  }
}

class _ViewState<T extends Controller> extends State<View<T>> with TickerProviderStateMixin {
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
