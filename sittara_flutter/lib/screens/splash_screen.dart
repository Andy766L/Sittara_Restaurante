import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sittara_flutter/screens/main_screen.dart';
import 'package:sittara_flutter/screens/login_screen.dart';
import 'package:sittara_flutter/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Timer(const Duration(seconds: 3), _checkAuthAndNavigate);
  }

  void _checkAuthAndNavigate() {
    if (mounted) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4C7BF3);
    const secondaryColor = Color(0xFF3a5fc7);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation.value),
                    child: child,
                  );
                },
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 70,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Sittara',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reserva tu mesa perfecta',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
