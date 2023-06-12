import 'package:flutter/material.dart';

import 'package:ta_anywhere/screens/browse.dart';
import 'package:ta_anywhere/screens/map.dart';
import 'package:ta_anywhere/screens/camera.dart';
import 'package:ta_anywhere/screens/profile.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectpage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List<Widget> _screens = [
    const BrowseScreen(),
    const MainMapScreen(),
    const CameraScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 29,
        onTap: _selectpage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search_outlined),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
