import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:ta_anywhere/screens/camera.dart';
import 'package:ta_anywhere/models/theme.dart';
import 'package:ta_anywhere/widget/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //native camera
  cameras = await availableCameras();

  //firebase auth
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      home: const WidgetTree(),
    );
  }
}
