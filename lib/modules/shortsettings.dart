import 'package:flutter/material.dart';
// import the about page - update path/class if your about page file or class name differs
import '../pages/about.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The original white box container
        FractionallySizedBox(
          widthFactor: 0.80,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: BoxBorder.all(color: Colors.black, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.dark_mode),
                          Text(
                            "Dark Mode",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications),
                          Text(
                            "Notifications",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Switch(
                        value: notificationsEnabled,
                        activeColor: Color(0xFF83BF4F),
                        onChanged: (bool value) {
                          setState(() {
                            notificationsEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              clearButton,
                            ),
                          ),
                          icon: Icon(Icons.delete, color: Colors.white),
                          label: Text(
                            "Clear History",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ABOUT US button outside the box and below it
        const SizedBox(height: 12),
        const SizedBox(height: 40),
        FractionallySizedBox(
          widthFactor: 0.6,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUs()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8FD85F),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: const StadiumBorder(),
                elevation: 2,
              ),
              child: const Text(
                'ABOUT US',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void clearHistory() {}

Color clearButton(Set<MaterialState> states) {
  if (states.contains(MaterialState.pressed)) {
    return Colors.red.shade500;
  } else {
    return Colors.red.shade600;
  }
}
