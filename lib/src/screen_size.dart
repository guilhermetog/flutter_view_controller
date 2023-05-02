import 'package:flutter/material.dart';

class ScreenSize {
  static final ScreenSize _instance = ScreenSize._();
  ScreenSize._();

  factory ScreenSize() => _instance;

  double _heightUnit = 0;
  double _widthUnit = 0;

  setContext(BuildContext context) {
    _instance._calculateSizes(context);
    return _instance;
  }

  _calculateSizes(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _heightUnit = media.size.height / 100;
    _widthUnit = media.size.width / 100;
  }

  double height(double percentage) {
    return _heightUnit * percentage;
  }

  double width(double percentage) {
    return _widthUnit * percentage;
  }

  double get screenWidth => width(100);
  double get screenHeight => height(100);
}
