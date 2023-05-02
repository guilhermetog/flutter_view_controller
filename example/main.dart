import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'app.dart';
import 'theme.dart';

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
