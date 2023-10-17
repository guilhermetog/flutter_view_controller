import 'package:flutter/material.dart';

typedef ScreenFractionBuilder = Widget Function(ScreenSize);

class ScreenSize {
  static double _safeHeight = 0;
  static double _safeWidth = 0;
  static double _paddingTop = 0;

  final double? _height;
  final double? _width;

  double get paddingTop => _paddingTop;

  const ScreenSize(this._height, this._width);

  factory ScreenSize.empty() => const ScreenSize(null, null);
  factory ScreenSize.only({double? height, double? width}) => ScreenSize(height, width);
  factory ScreenSize.percentage({double? height, double? width}) {
    double? innerHeight;
    double? innerWidth;

    if (height != null) innerHeight = _safeHeight * (height / 100);
    if (width != null) innerWidth = _safeWidth * (width / 100);

    return ScreenSize(innerHeight, innerWidth);
  }

  calculateSizes(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _safeHeight = media.size.height - media.padding.top;
    _safeWidth = media.size.width;
    _paddingTop = media.padding.top;
  }

  double height(double percentage) {
    double height = _height ?? _safeHeight;
    return height * (percentage / 100);
  }

  double width(double percentage) {
    double width = _width ?? _safeWidth;
    return width * (percentage / 100);
  }

  double screenHeight(double percentage) {
    return _safeHeight + paddingTop * (percentage / 100);
  }

  double screenWidth(double percentage) {
    return _safeWidth * (percentage / 100);
  }

  double safeHeight(double percentage) {
    return _safeHeight * (percentage / 100);
  }

  ScreenSize fraction({double? height, double? width}) {
    return ScreenSize(this.height(height ?? 100), this.width(width ?? 100));
  }
}
