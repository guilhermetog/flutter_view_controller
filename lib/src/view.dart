import 'package:flutter/material.dart';
import 'notifier.dart';

abstract class View<T extends Controller> extends StatefulWidget {
  final T controller;
  View({required this.controller}) : super(key: UniqueKey());
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
    return controller._refresh.show(() {
      controller.context = context;
      return widget.build(context);
    });
  }
}

abstract class Controller {
  bool _isInitialized = false;
  final NotifierTicker _refresh = NotifierTicker();
  BuildContext? context;

  onInit();
  onUpdate() {}
  onClose();

  _dispose() {
    onClose();
  }

  refresh() {
    onClose();
    onInit();
    _refresh.tick();
  }
}
