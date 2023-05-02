import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter/material.dart';

import 'icon_button.dart';
import 'theme.dart';

class AppController extends Controller {
  late IconButtonController buttonDark;
  late IconButtonController buttonLight;

  @override
  onInit() {
    _configButtonDark();
    _configButtonLight();
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
