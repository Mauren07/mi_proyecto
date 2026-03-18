import 'package:flutter/material.dart';

class SplashApp extends StatefulWidget {
  const SplashApp({super.key});

  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(255, 42, 115, 154),
              Color.fromARGB(255, 55, 176, 138),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset(
                  'assets/img/logos/dart.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Application Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Cargando...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
