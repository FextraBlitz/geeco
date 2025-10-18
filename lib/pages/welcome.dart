import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 45),
        child: PageView(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/WelcomePage1.png"),
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/WelcomePage2.png"),
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/WelcomePage3.png"),
                  fit: BoxFit.cover
                )
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        color: Color(0xFF022000),
        height: 45,
      ),
    );
  }
}