import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 40,
        mainAxisSpacing: 40,
      ),
      children: [],
    );
  }
}
