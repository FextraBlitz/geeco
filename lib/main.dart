// import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geeco/pages/rootpage.dart';
import 'package:scaled_size/scaled_size.dart';

// import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter's binding is initialized.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaledSize(
      builder: () {
        return const MaterialApp(
          home: RootPage()
        );
      }
    );
  }
}