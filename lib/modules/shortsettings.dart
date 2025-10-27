import 'package:flutter/material.dart';
import 'package:geeco/bax_end/theme_bax_end.dart';
import 'package:provider/provider.dart';
import '../pages/about.dart';

class ShortSettings extends StatefulWidget {
  const ShortSettings({super.key});

  @override
  State<ShortSettings> createState() => _ShortSettingsState();
}

class _ShortSettingsState extends State<ShortSettings> {
  bool darkModeOn = true;
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FractionallySizedBox(
          widthFactor: 0.80,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(5.0),
              border: BoxBorder.all(color: Theme.of(context).colorScheme.shadow, width: 1.0),
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
                SizedBox(width: 8), 
                          Text(
                            "Dark Mode",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Switch(
                        // This bool value toggles the switch.
                        value: Provider.of<ThemeSelector>(context).isDark,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: (bool value) {
                          Provider.of<ThemeSelector>(context, listen: false).toggle();
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
                            backgroundColor: WidgetStateProperty.resolveWith(
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
      ],
    );
  }
}

void clearHistory() {}

Color clearButton(Set<WidgetState> states) {
  if (states.contains(WidgetState.pressed)) {
    return Colors.red.shade500;
  } else {
    return Colors.red.shade600;
  }
}
