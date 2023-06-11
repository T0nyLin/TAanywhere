import 'package:flutter/material.dart';

import '../components/auth.dart';
import 'package:ta_anywhere/screens/login.dart';
import 'package:ta_anywhere/widget/tabs.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => WidgetTreeState();
}

class WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const TabsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
