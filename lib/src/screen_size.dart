import 'package:flutter/material.dart';

class ScreenSize {
  static double _totalHeight = 0;
  static double _totalWidth = 0;
  static double _paddingTop = 0;

  double _height = 0;
  double _width = 0;

  void defineHeight(double? height) {
    _height = height ?? _height;
  }

  void defineWidth(double? width) {
    _width = width ?? _width;
  }

  calculateSizes(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _totalHeight = media.size.height - media.padding.top;
    _totalWidth = media.size.width;
    _paddingTop = media.padding.top;
    if (_height != 0 && _width != 0) return;
    _height = _totalHeight;
    _width = _totalWidth;
  }

  double height(double percentage) {
    return _totalHeight * (percentage / 100);
  }

  double width(double percentage) {
    return _totalWidth * (percentage / 100);
  }

  double viewHeight(double percentage) {
    return _height * (percentage / 100);
  }

  double viewWidth(double percentage) {
    return _width * (percentage / 100);
  }

  double get screenWidth => width(100);
  double get screenHeight => height(100);
  double get paddingTop => _paddingTop;
}
