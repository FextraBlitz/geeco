import 'package:flutter/material.dart';

class ShortSettings extends StatefulWidget {
  const ShortSettings({super.key});

  @override
  State<ShortSettings> createState() => _ShortSettingsState();
}

class _ShortSettingsState extends State<ShortSettings> {
  bool darkMode = true;
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.80,
      child: Container(
        decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border:BoxBorder.all(
            color: Colors.black,
            width: 1.0
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children:[
                Icon(Icons.dark_mode),
                Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold))
                ]
              ),
              Switch(
                // This bool value toggles the switch.
                value: darkMode,
                activeColor: Color(0xFF83BF4F),
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    darkMode = value;
                  });
                },
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children:[
                Icon(Icons.notifications),
                Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold))
                ]
              ),
              Switch(
                value: notificationsEnabled,
                activeColor: Color(0xFF83BF4F),
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
              Expanded(
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(clearButton),
                  ),
                  icon: Icon(Icons.delete, color:Colors.white),
                  label: Text("Clear History", style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ),]
            ),]
          ),
        )
      )
    );
  }
}

void clearHistory(){

}

Color clearButton(Set<WidgetState> states) {
  if (states.contains(WidgetState.pressed)){
    return Colors.red.shade500;
  }
  else {
    return Colors.red.shade600;
  }
}