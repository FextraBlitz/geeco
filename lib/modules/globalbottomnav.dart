import 'package:flutter/material.dart';

GlobalKey navbarKey = GlobalKey();

class GlobalBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const GlobalBottomNavigationBar({super.key, required this.selectedIndex, required this.onItemTapped});
  

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        key: navbarKey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, color: Colors.white),
            label: 'Home',
            backgroundColor: Color(0xFF022000)
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            label: 'Scanner',
            backgroundColor: Color(0xFF022000)
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.grass_rounded, color: Colors.white),
            label: 'Editor',
            backgroundColor: Color(0xFF022000)
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
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