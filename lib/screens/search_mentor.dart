import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ta_anywhere/widget/tabs.dart';

class SearchMentorScreen extends StatelessWidget {
  const SearchMentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,     //disable system back button
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.beat(color: const Color.fromARGB(255, 48, 97, 104), size: 100),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Searching for mentor...',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 30,
                  shadows: <Shadow>[
                    Shadow(color: Colors.black, blurRadius: 10.0)
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TabsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.home, color: Color.fromARGB(255, 48, 97, 104),),
              label: const Text('Back to Browse'),
            ),
          ],
        ),
      ),
    );
  }
}
