import 'package:flutter/material.dart';

abstract class UIComponent {
  late BuildContext context;
  late Size _size;
  VoidCallback? _onUpdate;

  void setUpdateCallback(VoidCallback callback) {
    _onUpdate = callback;
  }

  void dispose() {
    _onUpdate = null;
  }

  void render() {
    _onUpdate?.call();
  }

  Widget build(BuildContext context);

  double width(double percentage) {
    return _size.width * (percentage / 100);
  }

  double height(double percentage) {
    return _size.height * (percentage / 100);
  }

  double font(double percentage) {
    return width(percentage) / (width(30) / height(100));
  }
}

class LayoutUI extends StatefulWidget {
  final double? width;
  final double? height;
  final UIComponent child;

  const LayoutUI({this.width, this.height, required this.child})
      : super(key: null);

  @override
  _LayoutUIState createState() => _LayoutUIState();
}

class _LayoutUIState extends State<LayoutUI> {
  @override
  void initState() {
    super.initState();
    widget.child.setUpdateCallback(_handleUpdate);
  }

  void _handleUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.child.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var size = constraints.biggest;
      if (size.width > MediaQuery.of(context).size.width) {
        size = Size(MediaQuery.of(context).size.width, size.height);
      }
      if (size.height > MediaQuery.of(context).size.height) {
        size = Size(size.width, MediaQuery.of(context).size.height);
      }
      widget.child._size =
          Size(widget.width ?? size.width, widget.height ?? size.height);
      widget.child.context = context;
      return widget.child.build(context);
    });
  }
}
