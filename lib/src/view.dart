import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/src/positioner/positioner.dart';
import 'dart:async';

import 'animation/global_ticker_provider.dart';

abstract class ViewOf<T extends Controller> extends StatefulWidget {
  final T controller;
  final Sizer size;

  // ignore: prefer_const_constructors_in_immutables
  ViewOf({
    super.key,
    required this.controller,
    this.size = const Sizer(null, null),
  });

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

      if (widget.controller._hasTicker) {
        return GlobalTickerProviderWidget(child: w);
      } else {
        return w;
      }
    });
  }
}

abstract class Controller {
  late Sizer size;
  final NotifierTicker _refresh = NotifierTicker();
  late BuildContext context;
  late String _viewType;
  late String _controllerType;
  Positioner? _positioner;
  bool _alreadyInitialized = false;
  bool _alreadyReady = false;
  bool _hasTicker = false;

  bool get readyCondition => true;
  Positioner get position {
    if (_positioner == null) {
      Offset offset =
          (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
      _positioner = Positioner(
        position: offset,
        size: Size(
          size.width(100),
          size.height(100),
        ),
      );
    }
    return _positioner!;
  }

  Plug onReady = Plug();

  Controller() {
    _controllerType = runtimeType.toString();
  }

  onInit();
  onUpdate(String? lastRouteName) {}
  onClose();

  _setSize(Sizer size) {
    this.size = size;
  }

  _setNavigatorMonitor(String view) {
    _viewType = view;
  }

  _setContext(context) {
    this.context = context;
    Sizer.calculateSize(context);
  }

  _initialize() {
    _alreadyInitialized = true;
    onInit();
  }

  _ready() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (readyCondition) {
        timer.cancel();
        FVCNavigatorMonitor().onFocus(_viewType, _update);
        if (!_alreadyReady) {
          _alreadyReady = true;
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
    controller._hasTicker = true;
    return _ControllerRepository().register(controller);
  }
}

class _ControllerRepository {
  static final Map<String, Controller> _controllers = {};

  T register<T extends Controller>(T controller) {
    if (_controllers.containsKey(controller._controllerType)) {
      return _controllers[controller._controllerType] as T;
    } else {
      _controllers[controller._controllerType] = controller;
      return controller;
    }
  }

  void remove<T extends Controller>(T controller) {
    _controllers.removeWhere((key, value) => key == controller._controllerType);
  }
}
