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
  seedColor: const Color.fromARGB(255, 49, 83, 139),
  background: const Color.fromARGB(255, 49, 83, 139),
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
