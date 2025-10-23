import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:geeco/modules/globalbottomnav.dart';
import 'package:geeco/pages/homepage.dart';
import 'package:geeco/pages/scans.dart';
import 'package:geeco/pages/editor.dart';
import 'package:geeco/pages/settings.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  double appBarBorderRadius = 100000.0;

  final List<Widget> _pages = [
    HomePage(),
    ScansPage(),
    EditorPage(),
    SettingsPage(),
  ];

  final List<String> _pageNames = const [
    "Home",
    "Eco-Lens",
    "Digital Habitat Builder",
    "Settings",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        appBarBorderRadius = 0.0;
      } else {
        appBarBorderRadius = 100000.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 8.0, right: 8.0),
            child: Material(
              elevation: 6,
              color: Colors.transparent,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Padding(
                  // smaller left padding so title sits closer to the separator
                  padding: const EdgeInsets.only(left: 10.0, right: 16.0),
                  child: Row(
                    children: [
                      // logo: adjust path/size as needed
                      SizedBox(
                        width: 26,
                        height: 26,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ), // reduce gap between logo and separator
                      // white vertical separator between logo and title
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      // increase gap so the page name sits a bit to the right
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _pageNames[_selectedIndex],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Gabarito",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: LazyLoadIndexedStack(
        index: _selectedIndex,
        autoDisposeIndexes: List.generate(_pages.length, (i) => i),
        children: _pages,
      ),
      bottomNavigationBar: GlobalBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
