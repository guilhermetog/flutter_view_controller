import 'package:flutter/material.dart';

typedef ScreenFractionBuilder = Widget Function(ScreenSize);

class ScreenSize {
  static double _safeHeight = 0;
  static double _safeWidth = 0;
  static double _paddingTop = 0;
  static double _paddingBottom = 0;

  final double? _height;
  final double? _width;

  double get paddingTop => _paddingTop;
  double get paddingBottom => _paddingBottom;
  bool get isEmpty => _height == null && _width == null;

  const ScreenSize(this._height, this._width);

  calculateSizes(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _safeHeight = media.size.height - media.padding.top - media.padding.bottom;
    _safeWidth = media.size.width;
    _paddingTop = media.padding.top;
    _paddingBottom = media.padding.bottom;
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
    return (_safeHeight + paddingTop + paddingBottom) * (percentage / 100);
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

class PercentageScreenSize extends ScreenSize {
  const PercentageScreenSize(super.height, super.width);
  @override
  double height(double percentage) {
    double height = _height == null ? ScreenSize._safeHeight : ScreenSize._safeHeight * (_height! / 100);
    return height * (percentage / 100);
  }

  @override
  double width(double percentage) {
    double width = _width == null ? ScreenSize._safeWidth : ScreenSize._safeWidth * (_width! / 100);
    return width * (percentage / 100);
  }
}
