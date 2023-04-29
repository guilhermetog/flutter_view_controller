import 'package:flutter/material.dart';

class ScreenSize {
  static ScreenSize? _instance;

  ScreenSize._(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _heightUnit = (media.size.height - (media.padding.top * 2)) / 100;
    _widthUnit = media.size.width / 100;
  }

  factory ScreenSize(BuildContext context) {
    _instance ??= ScreenSize._(context);
    return _instance!;
  }

  double _heightUnit = 0;
  double _widthUnit = 0;

  double height(double percentage) {
    return _heightUnit * percentage;
  }

  double width(double percentage) {
    return _widthUnit * percentage;
  }

  double get screenWidth => width(100);
  double get screenHeight => height(100);
}
