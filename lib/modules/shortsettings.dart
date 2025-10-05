import 'package:flutter/material.dart';

class ShortSettings extends StatefulWidget {
  const ShortSettings({super.key});

  @override
  State<ShortSettings> createState() => _ShortSettingsState();
}

class _ShortSettingsState extends State<ShortSettings> {
  bool var1 = true;
  bool var2 = false;

  void handle(value){
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Switch(
        // This bool value toggles the switch.
        value: var1,
        activeColor: Colors.red,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            var1 = value;
            var2 = !value;
          });
        },
      ),
      Switch(
        // This bool value toggles the switch.
        value: var2,
        activeColor: Colors.red,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            var2 = value;
            var1 = !value;
          });
        },
      ) 
    ],);
    // return const Placeholder(fallbackWidth: 50, fallbackHeight: 50, color: Color(0xFFFFAAAA),);
  }
}