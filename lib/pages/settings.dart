import 'package:flutter/material.dart';
import 'package:geeco/modules/shortsettings.dart';
// replaced test_about import with about page
import 'package:geeco/pages/about.dart';
// import 'package:geeco/state/app_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF83BF4F);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShortSettings(),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              // Open the real About page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUs()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: Colors.black.withAlpha(38),
              padding: const EdgeInsets.symmetric(
                horizontal: 36.0,
                vertical: 14.0,
              ),
              minimumSize: const Size(220, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              'ABOUT US',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
