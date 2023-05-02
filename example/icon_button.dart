import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

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
