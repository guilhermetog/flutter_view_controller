import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// This widget will hold the state required to create tickers globally.
class GlobalTickerProviderWidget extends StatefulWidget {
  final Widget child;

  const GlobalTickerProviderWidget({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _GlobalTickerProviderWidgetState createState() =>
      _GlobalTickerProviderWidgetState();
}

class _GlobalTickerProviderWidgetState extends State<GlobalTickerProviderWidget>
    with SingleTickerProviderStateMixin {
  static _GlobalTickerProviderWidgetState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  static Ticker createGlobalTicker(TickerCallback onTick) {
    return _instance!.createTicker(onTick);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class GlobalTickerProvider {
  static final GlobalTickerProvider _instance =
      GlobalTickerProvider._internal();

  factory GlobalTickerProvider() {
    return _instance;
  }

  GlobalTickerProvider._internal();

  Ticker createTicker(TickerCallback onTick) {
    return _GlobalTickerProviderWidgetState.createGlobalTicker(onTick);
  }
}
