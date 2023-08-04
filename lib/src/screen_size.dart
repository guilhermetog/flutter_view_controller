import 'package:flutter/material.dart';

class ScreenSize {
  static double _totalHeight = 0;
  static double _totalWidth = 0;
  static double _paddingTop = 0;

  double _height = 0;
  double _width = 0;

  void defineHeight(double? height) {
    if (_height == 0) {
      _height = height ?? _totalHeight;
    }
  }

  void defineWidth(double? width) {
    if (_width == 0) {
      _width = width ?? _totalWidth;
    }
  }

  calculateSizes(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _totalHeight = media.size.height - media.padding.top;
    _totalWidth = media.size.width;
    _paddingTop = media.padding.top;
  }

  double height(double percentage) {
    return _totalHeight * (percentage / 100);
  }

  double width(double percentage) {
    return _totalWidth * (percentage / 100);
  }

  double viewHeight(double percentage) {
    double height = _height == 0 ? _totalHeight : _height;
    return height * (percentage / 100);
  }

  double viewWidth(double percentage) {
    double width = _width == 0 ? _totalWidth : _width;
    return width * (percentage / 100);
  }

  double safeHeight(double percentage) {
    return height(percentage) + _paddingTop * (percentage / 100);
  }

  double get screenWidth => width(100);
  double get screenHeight => height(100);
  double get paddingTop => _paddingTop;
}
