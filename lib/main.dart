import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachable_ml/view/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reconhecimento de EPI',
      theme: _buildTheme(),
      home: HomePage(),
    );
  }

  _buildTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF212121),
      accentColor: Colors.black,
      primarySwatch: Colors.deepPurple,
    );
  }
}