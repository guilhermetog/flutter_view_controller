import 'package:flutter/material.dart';

abstract class ThemeContract {
  late Color foregroundColor;
  late Color backgroundColor;
  late Color backgroundDisableColor;
}

class ThemeLight implements ThemeContract {
  @override
  Color backgroundColor = Colors.white;

  @override
  Color foregroundColor = Colors.grey.shade600;

  @override
  Color backgroundDisableColor = Colors.grey.shade200;
}

class ThemeDark implements ThemeContract {
  @override
  Color backgroundColor = Colors.black;

  @override
  Color foregroundColor = Colors.white;

  @override
  Color backgroundDisableColor = Colors.grey.shade700;
}
