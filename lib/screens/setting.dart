import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/screens/profile.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final User? user = Auth().currentUser;
  
  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }
  
  Widget _backButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pop(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    },
    child: const Text("Back"),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _userUid(),
                  _backButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
