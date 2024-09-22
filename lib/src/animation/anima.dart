import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'global_ticker_provider.dart';

class Anima {
  static final Anima _instance = Anima._internal();
  final List<_AnimationCallback> _callbacks = [];
  Ticker? _ticker;

  factory Anima() {
    return _instance;
  }

  Anima._internal();

  Future<void> start(
      void Function(double value) callback, Duration duration) async {
    final _AnimationCallback animCallback =
        _AnimationCallback(callback, duration);
    _callbacks.add(animCallback);

    if (_ticker == null) {
      _startTicker();
    }

    await animCallback.completer.future;
  }

  void _startTicker() {
    _ticker = GlobalTickerProvider().createTicker((elapsed) {
      final currentTime = DateTime.now();
      _callbacks.removeWhere((animCallback) {
        final progress = animCallback.update(currentTime);
        return progress >= 1.0;
      });

      if (_callbacks.isEmpty) {
        _ticker?.stop();
        _ticker = null;
      }
    });

    _ticker!.start();
  }
}

class _AnimationCallback {
  final void Function(double) callback;
  final Duration duration;
  final DateTime startTime;
  final Completer<void> completer;

  _AnimationCallback(this.callback, this.duration)
      : startTime = DateTime.now(),
        completer = Completer();

  double update(DateTime currentTime) {
    final elapsedTime = currentTime.difference(startTime);
    final progress =
        (elapsedTime.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    callback(progress);

    if (progress >= 1.0) {
      completer.complete();
    }

    return progress;
  }
}

extension Range on double {
  double over(double from, double to) {
    return (to - from) * this + from;
  }
}
