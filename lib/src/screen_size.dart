import 'package:flutter/material.dart';

class ScreenSize {
  static double _totalHeight = 0;
  static double _totalWidth = 0;
  static double _appHeight = 0;
  static double _appWidth = 0;
  static double _statusBarHeight = 0;
  double _height = 0;
  double _width = 0;

  void defineHeight(double? height) {
    if (_height == 0) {
      _height = height ?? _appHeight;
    }
  }

  void defineWidth(double? width) {
    if (_width == 0) {
      _width = width ?? _appWidth;
    }
  }

  calculateSizes(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _totalHeight = media.size.height;
    _totalWidth = media.size.width;
    _appHeight = media.size.height - media.padding.top;
    _appWidth = media.size.width;
    _statusBarHeight = media.padding.top;
  }

  double screenHeight(double percentage) {
    return _totalHeight * (percentage / 100);
  }

  double screenWidth(double percentage) {
    return _totalWidth * (percentage / 100);
  }

  double height(double percentage) {
    double height = _height == 0 ? _appHeight : _height;
    return height * (percentage / 100);
  }

  double width(double percentage) {
    double width = _width == 0 ? _appWidth : _width;
    return width * (percentage / 100);
  }

  double get paddingTop => _statusBarHeight;
}
