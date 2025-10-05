import 'package:flutter/material.dart';

class GlobalBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const GlobalBottomNavigationBar({super.key, required this.selectedIndex, required this.onItemTapped});
  

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF022000)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Scanner',
            backgroundColor: Color(0xFF022000)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass_rounded),
            label: 'Editor',
            backgroundColor: Color(0xFF022000)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
            backgroundColor: Color(0xFF022000)
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF3ACF72),
        onTap: onItemTapped,
      );
  }
}