import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'dart:async';

abstract class ViewOf<T extends Controller> extends StatefulWidget {
  final T controller;
  final ScreenSize size;

  const ViewOf({super.key, required this.controller, this.size = const ScreenSize(null, null)});
  Widget build(BuildContext context);

  @override
  State<ViewOf<T>> createState() => _ViewOfState<T>();
}

class _ViewOfState<T extends Controller> extends State<ViewOf<T>> {
  void _initialize(BuildContext context) {
    if (!widget.controller._alreadyInitialized) {
      widget.controller._setNavigatorMonitor(widget.runtimeType.toString());
      widget.controller._setSize(widget.size);
      widget.controller._setContext(context);
      widget.controller._initialize();
    } else {
      widget.controller._setContext(context);
    }
  }

  @override
  void dispose() {
    widget.controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller._refresh.show(() {
      _initialize(context);
      Widget w = widget.build(context);
      widget.controller._ready();
      return w;
    });
  }
}

abstract class Controller {
  late ScreenSize size;
  final NotifierTicker _refresh = NotifierTicker();
  late BuildContext context;
  late String _viewType;
  bool _alreadyInitialized = false;

  bool get readyCondition => true;

  Plug onReady = Plug();

  onInit();
  onUpdate(String? lastRouteName) {}
  onClose();

  _setSize(ScreenSize size) {
    this.size = size;
  }

  _setNavigatorMonitor(String view) {
    _viewType = view;
    FVCNavigatorMonitor().onFocus(_viewType, _update);
  }

  _setContext(context) {
    this.context = context;
    size.calculateSizes(context);
  }

  _initialize() {
    _alreadyInitialized = true;
    onInit();
  }

  _ready() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (readyCondition) {
        timer.cancel();
        if (onReady.isConnected) {
          onReady();
        }
      }
    });
  }

  _update(String? lastRouteName) {
    refresh();
    onUpdate(lastRouteName);
  }

  _dispose() {
    FVCNavigatorMonitor().removeListener(_viewType);
    _ControllerRepository().remove(this);
    onClose();
  }

  refresh() {
    _refresh.tick();
  }

  reload() async {
    await onClose();
    await onInit();
    refresh();
  }

  static T register<T extends Controller>(T controller) {
    return _ControllerRepository().register(controller);
  }
}

class _ControllerRepository {
  static final Map<Type, Controller> _controllers = {};

  T register<T extends Controller>(T controller) {
    if (_controllers.containsKey(T)) {
      return _controllers[T] as T;
    } else {
      _controllers[T] = controller;
      return controller;
    }
  }

  void remove<T extends Controller>(T controller) {
    if (_controllers.containsValue(controller)) {
      _controllers.removeWhere((key, value) => value.hashCode == controller.hashCode);
    }
  }
}
