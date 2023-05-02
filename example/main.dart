// This is a basic example of an app with two buttons that changes the app theme
// to dark and light mode.

// This example contains four files:
//
// main.dart : basic main to run the app
// app.dart : a fvc component containing two icon buttons
// icon_button : a fvc component representing the icon button
// theme : a file with themes to use in the app

// You can run this file directly as a flutter app or
// you can copy and paste each marked parts to it's repectives files
// so you can see it more cleary

//--------------------------------------
// main.dart
//---------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalState<ThemeContract>().register(ThemeDark());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppView(controller: AppController()),
    );
  }
}

//---------------------------------------
//app.dart
//---------------------------------------

class AppController extends Controller {
  late IconButtonController buttonDark;
  late IconButtonController buttonLight;

  @override
  onInit() {
    _configButtonDark();
    _configButtonLight();
    _changeToDark();
  }

  _configButtonDark() {
    buttonDark = IconButtonController();
    buttonDark.icon = Icons.dark_mode;
    buttonDark.onClick.then(_changeToDark);
  }

  _configButtonLight() {
    buttonLight = IconButtonController();
    buttonLight.icon = Icons.light_mode;
    buttonLight.onClick.then(_changeToLight);
  }

  _changeToDark() {
    buttonDark.enable();
    buttonLight.disable();
    GlobalState<ThemeContract>().current = ThemeDark();
  }

  _changeToLight() {
    buttonDark.disable();
    buttonLight.enable();
    GlobalState<ThemeContract>().current = ThemeLight();
  }

  @override
  onClose() {}
}

class AppView extends View<AppController> {
  AppView({required AppController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: GlobalState<ThemeContract>().current.backgroundColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButtonView(controller: controller.buttonDark),
            IconButtonView(controller: controller.buttonLight),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------
// icon_button.dart
//----------------------------------------

class IconButtonController extends Controller {
  late IconData icon;

  Plug onClick = Plug();
  final Notifier<bool> _isEnabled = Notifier(false);

  @override
  onInit() {}

  enable() => _isEnabled.value = true;

  disable() => _isEnabled.value = false;

  _click() {
    if (!_isEnabled.value) onClick();
  }

  @override
  onClose() {}
}

class IconButtonView extends View<IconButtonController> {
  IconButtonView({required IconButtonController controller})
      : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    ThemeContract theme = GlobalState<ThemeContract>().current;
    return controller._isEnabled.show(
      (isEnabled) => GestureDetector(
        onTap: controller._click,
        child: Container(
          height: size.height(10),
          width: size.height(10),
          margin: EdgeInsets.all(size.height(5)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isEnabled
                ? theme.backgroundColor
                : theme.backgroundDisableColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 4,
                color: theme.foregroundColor.withOpacity(0.4),
              )
            ],
            borderRadius: BorderRadius.circular(size.height(10)),
          ),
          child: Icon(
            controller.icon,
            size: size.height(3),
            color: theme.foregroundColor,
          ),
        ),
      ),
    );
  }
}

//---------------------------------
// theme.dart
//----------------------------------

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
