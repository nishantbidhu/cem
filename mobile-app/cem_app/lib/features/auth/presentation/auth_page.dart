

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart'; // DRY Principle for Hostels
import '../data/auth_service.dart';
import '../../../core/cem_logo.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _pageController = PageController();

  String? _selectedHostel; 
  
  // Controllers for Sign In
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers for Sign Up
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpPhoneController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpNameController.dispose();
    _signUpPhoneController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // --- REAL SIGN IN LOGIC ---
  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed: ${e.toString()}"), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- REAL SIGN UP & FIRESTORE LOGIC ---
  // --- REAL SIGN UP & FIRESTORE LOGIC ---
  Future<void> _handleSignUp() async {
    // Check if name is empty
    if (_signUpNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your full name"), backgroundColor: Colors.redAccent));
      return;
    }

    if (_selectedHostel == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a hostel"), backgroundColor: Colors.redAccent));
      return;
    }


    final String emailInput = _signUpEmailController.text.trim().toLowerCase();
    if (!emailInput.endsWith('@iitj.ac.in') && emailInput != 'cemiitjtest@gmail.com') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access restricted to @iitj.ac.in emails only"), backgroundColor: Colors.redAccent)
      );
      return;
    }


    setState(() => _isLoading = true);
    try {
      // 1. Create the Auth user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _signUpEmailController.text.trim(),
        password: _signUpPasswordController.text.trim(),
      );

      // 2. Create the Firestore User Document
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': _signUpNameController.text.trim(), // <-- ADDED NAME HERE
          'email': userCredential.user!.email,
          'hostel': _selectedHostel,
          'phone': _signUpPhoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'student',
        });
      }

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Failed: ${e.toString()}"), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildSignInPage(),
          _buildSignUpPage(),
        ],
      ),
    );
  }

  Widget _buildSignInPage() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CemLogo(size: 100),
            const SizedBox(height: 20),
            RichText(text: const TextSpan(style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white), children: [TextSpan(text: "CEM"), TextSpan(text: ".", style: TextStyle(color: Color(0xFFFFB74D))), TextSpan(text: "IITJ")])),
            const Text("Exchange. Reuse. Connect.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            _buildInputCard(title: "INSTITUTIONAL EMAIL", hint: "roll_number@iitj.ac.in", icon: Icons.email, controller: _emailController),
            const SizedBox(height: 20),
            _buildInputCard(title: "PASSWORD", hint: "••••••••", icon: Icons.lock, isPassword: true, controller: _passwordController),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  if (_emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your email first to reset password"), backgroundColor: Colors.orange));
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset link sent! Check your inbox."), backgroundColor: Colors.green));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent));
                  }
                },
                child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFFFFB74D), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            _buildPrimaryButton("SIGN IN", onTap: _handleSignIn, isLoading: _isLoading),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                GestureDetector(
                  onTap: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                  child: const Text("Register now", style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPage() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB74D)), onPressed: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
            const SizedBox(height: 20),
            const Text("Join CEM", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
            const Text("Create your IITJ Marketplace identity.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
            const SizedBox(height: 40),
            _buildInputCard(title: "FULL NAME", hint: "Your Name", icon: Icons.person, controller: _signUpNameController),
            const SizedBox(height: 20),
            _buildInputCard(title: "PHONE NUMBER", hint: "+91 99999 99999", icon: Icons.phone, controller: _signUpPhoneController),
            const SizedBox(height: 20),
            _buildInputCard(title: "IITJ EMAIL", hint: "roll_no@iitj.ac.in", icon: Icons.email, controller: _signUpEmailController),
            const SizedBox(height: 20),
            const Text("HOSTEL", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedHostel, 
                  hint: const Text("Select Hostel", style: TextStyle(color: Colors.white24, fontSize: 14)),
                  dropdownColor: const Color(0xFF0A1128),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFB74D)),
                  // USING APP CONSTANTS HERE
                  items: AppConstants.hostels.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) setState(() => _selectedHostel = newValue);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputCard(title: "SET PASSWORD", hint: "••••••••", isPassword: true, controller: _signUpPasswordController),
            const SizedBox(height: 40),
            _buildPrimaryButton("CREATE MY ACCOUNT", onTap: _handleSignUp, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({required String title, required String hint, IconData? icon, bool isPassword = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: controller, obscureText: isPassword, style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(icon: icon != null ? Icon(icon, color: const Color(0xFFFFB74D), size: 20) : null, hintText: hint, hintStyle: const TextStyle(color: Colors.white24, fontSize: 14), border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(String text, {required VoidCallback onTap, bool isLoading = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
      ),
    );
  }

  
}