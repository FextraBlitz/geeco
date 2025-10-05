import 'package:flutter/material.dart';
import 'package:geeco/modules/globalbottomnav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:Text(
          "Example page", 
          style: TextStyle(
            color: Colors.white
          )
        )),
        backgroundColor: Color(0xFF022000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100000), bottomRight: Radius.circular(100000)),
        ),
      ),
      body: Center(child: Text("Hello!")),
      bottomNavigationBar: GlobalBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped
      ),
    );
  }
}