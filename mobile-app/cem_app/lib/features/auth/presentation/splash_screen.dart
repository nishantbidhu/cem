import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// IMPORTANT: Update this import path to wherever you saved the cem_logo.dart file!
import '../../../core/cem_logo.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Smooth fade-in animation for the logo
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();

    // Check auth status and navigate after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      body: Stack(
        children: [
          // --- MAIN CENTERED CONTENT ---
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Keeps the column tight in the center
                children: [
                  const CemLogo(size: 150), 
                  
                  const SizedBox(height: 30),
                  
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                      children: [
                        TextSpan(text: "CEM"),
                        TextSpan(text: ".", style: TextStyle(color: Color(0xFFFFB74D))),
                        TextSpan(text: "IITJ"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Exchange. Reuse. Connect.",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTTOM BRANDING ---
          Positioned(
            bottom: 40, // Adjust this to move it higher or lower
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    "made by IIT Jodhpur",
                    style: TextStyle(
                      color: Color(0xFF94A3B8), 
                      fontSize: 12, 
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Using the exact filename from your screenshot
                  Image.asset(
                    'assets/iit_logo.png', 
                    height: 45, // Keeps the IIT logo appropriately sized
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}