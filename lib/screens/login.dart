import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(width: 100, height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Please login to continue.",
                  style: TextStyle(fontSize: 20),
                )),
                const SizedBox(width: 100, height: 50),
                const TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                )),
                const SizedBox(width: 100, height: 15),
                const TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                )),
                const SizedBox(width: 100, height: 15),
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
            ))));
  }
}
