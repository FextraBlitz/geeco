import 'package:flutter/material.dart';
import 'package:geeco/pages/splashthree.dart';

class DigitalHabitatPage extends StatefulWidget {
  const DigitalHabitatPage({super.key});

  @override
  State<DigitalHabitatPage> createState() => _DigitalHabitatPageState();
}

class _DigitalHabitatPageState extends State<DigitalHabitatPage> {
  double _opacity = 0.0;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _opacity = 1.0));
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _canContinue = true);
    });
  }

  void _continue() {
    if (!_canContinue) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const EcoLensPage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _continue,
      child: Scaffold(
        backgroundColor: const Color(0xFF022000),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _opacity,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          // Logo already has a circular background, show it directly
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: Image.asset(
                              'assets/images/dhblogo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Title
                          const Text(
                            'Digital Habitat Builder',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF3ACF72),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Paragraphs
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Build and edit your own digital habitats with the Digital Habitat Builder and evaluate its environmental status as well!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'You can also use pictures that you\'ve taken using the Eco-Lens so you would be able to know how to improve the environment of your area!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              'Digital Habitats made can also be saved and loaded from the Home Page.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // bottom "tap anywhere" hint
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _canContinue ? 1.0 : 0.0,
                      child: Text(
                        _canContinue ? 'Tap anywhere to continue' : '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(
                            _canContinue ? 0.9 : 0,
                          ),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
