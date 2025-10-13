import 'package:flutter/material.dart';
import 'package:geeco/modules/globalbottomnav.dart';
import 'package:geeco/pages/homepage.dart';
import 'package:geeco/pages/scans.dart';
import 'package:geeco/pages/editor.dart';
import 'package:geeco/pages/settings.dart';
import 'package:geeco/pages/about.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ScansPage(),
    EditorPage(),
    SettingsPage(),
    AboutUs(),
  ];

  final List<String> _pageNames = const [
    "Home",
    "Eco-Lens",
    "Editor",
    "Settings",
    "About",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _pageNames[_selectedIndex],
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF022000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100000),
            bottomRight: Radius.circular(100000),
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: GlobalBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
