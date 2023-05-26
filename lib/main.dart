import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:ta_anywhere/screens/login.dart';
import 'package:ta_anywhere/screens/camera.dart';
import 'package:ta_anywhere/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme(context),
      home: const LoginScreen(),
    );
  }
}
