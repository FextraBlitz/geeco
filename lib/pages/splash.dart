import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geeco/pages/splashtwo.dart';
import 'package:geeco/pages/rootpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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

  void _continue() async {
    if (!_canContinue) return;
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_intro') ?? false;
    if (seen) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const RootPage()));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DigitalHabitatPage()),
      );
    }
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ), // was 24.0 — reduced
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _opacity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // logo moved up
                        Transform.translate(
                          offset: const Offset(0, -28),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // overlap text into the logo area
                              Transform.translate(
                                offset: const Offset(-16, -8),
                                child: const Text(
                                  'eeco',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // space for Hello + welcome
                        const SizedBox(height: 60),

                        const Text(
                          'Hello!',
                          style: TextStyle(
                            color: Color(0xFF3ACF72),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // welcome text(keeps it centered)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ), // match outer padding
                          child: Text(
                            'Welcome to Geeco! See your world differently to analyze, improve, and preserve life on land using the features available on this app!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // bottom "tap anywhere" hint
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
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
