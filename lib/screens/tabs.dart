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

  @override
  Widget build(BuildContext context) {
    Widget activePage = const BrowseScreen();
    var activePagetitle = 'Browse';

    if (_selectedPageIndex == 1) {
      activePage = const MapScreen();
      activePagetitle = 'Map';
    }
    if (_selectedPageIndex == 2) {
      activePage = const CameraScreen();
      activePagetitle = 'Camera';
    }
    if (_selectedPageIndex == 3) {
      activePage = const ProfileScreen();
      activePagetitle = 'My Profile';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePagetitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
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
