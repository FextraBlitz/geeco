import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geeco/pages/rootpage.dart';

class EcoLensPage extends StatefulWidget {
  const EcoLensPage({super.key});

  @override
  State<EcoLensPage> createState() => _EcoLensPageState();
}

class _EcoLensPageState extends State<EcoLensPage> {
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
    await prefs.setBool('seen_intro', true);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const RootPage()));
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
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: Image.asset(
                              'assets/images/ecolenslogo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 28),

                          const Text(
                            'Eco-Lens',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF3ACF72),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Analyze the environmental status of your area with AI-powered evaluation using the Eco-Lens!',
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
                              'All it needs are three pictures of environmental aspects of your area and an evaluation will be made ready!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
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
                            _canContinue ? 0.9 : 0.0,
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
