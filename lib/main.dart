import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:ta_anywhere/screens/login.dart';
import 'package:ta_anywhere/screens/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const App());
}

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 255, 255, 255),
  background: Color.fromARGB(255, 207, 252, 244),
  primary: Colors.black,
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const LoginScreen(),
    );
  }
}
