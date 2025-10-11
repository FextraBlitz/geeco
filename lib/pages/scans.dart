import 'package:flutter/material.dart';
import 'package:scaled_size/scaled_size.dart';

class ScansPage extends StatefulWidget {
  const ScansPage({super.key});

  @override
  State<ScansPage> createState() => _ScansPageState();
}

class _ScansPageState extends State<ScansPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          Expanded(
            child: Padding(
              padding:EdgeInsetsGeometry.symmetric(horizontal: 2.0.rem, vertical: 1.0.rem),
              child:ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(captureButton),
                ),
                icon: Icon(Icons.camera, color:Colors.white),
                label: Text("Take a Photo", style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            ),
          ),]
        )
      ]
    );
  }
}

Color captureButton(Set<WidgetState> states) {
  if (states.contains(WidgetState.pressed)){
    return Color(0xFF3ACF72);
  }
  else {
    return Color(0xFF3ACF72);
  }
}