import 'package:flutter/material.dart';
import 'package:scaled_size/scaled_size.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return ScaledSize(
      size:Size(ScaledSizeUtil.screenWidth, ScaledSizeUtil.screenHeight),
      builder: () {
        return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 0.2,
              image: AssetImage('assets/images/homepage_bg.png'),
              fit: BoxFit.contain
            )
          ),
          child: Center(
            child: Text("No habitats yet, Scan or Edit to get started!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 1.25.rem))
          )
        );
      }
    );
  }
}