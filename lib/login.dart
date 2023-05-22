import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void login() {
    print("Go To Next Page");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("TAanywhere"),
          backgroundColor: Colors.cyan[200],
        ),
        body: Column(
          children: [
            const Text("Login"),
            const Text("Please sign in to continue."),
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Email",
            )),
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            )),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 193, 217, 220),
                    Color.fromARGB(255, 1, 104, 107)
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 3,
                  minimumSize: const Size(150, 60),
                ),
                onPressed: login,
                child: const Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}