// import 'package:flutter/material.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(), // Prevent swiping
//         children: [
//           _buildSignInPage(),
//           _buildSignUpPage(),
//         ],
//       ),
//     );
//   }

//   // --- SIGN IN UI (Screenshot 11.31.24) ---
//   Widget _buildSignInPage() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Logo Section
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFF8C00),
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: const Icon(Icons.bolt, color: Colors.white, size: 50),
//           ),
//           const SizedBox(height: 20),
//           RichText(
//             text: const TextSpan(
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
//               children: [
//                 TextSpan(text: "CEM"),
//                 TextSpan(text: ".", style: TextStyle(color: Color(0xFFFFB74D))),
//                 TextSpan(text: "IITJ"),
//               ],
//             ),
//           ),
//           const Text("Exchange. Reuse. Connect.", 
//             style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)),
          
//           const SizedBox(height: 50),

//           // Input Card
//           _buildInputCard(
//             title: "INSTITUTIONAL EMAIL",
//             hint: "roll_number@iitj.ac.in",
//             icon: Icons.email,
//           ),
//           const SizedBox(height: 20),
//           _buildInputCard(
//             title: "PASSWORD",
//             hint: "••••••••",
//             icon: Icons.lock,
//             isPassword: true,
//           ),

//           const SizedBox(height: 30),

//           // Sign In Button
//           _buildPrimaryButton("SIGN IN", onTap: () => Navigator.pushReplacementNamed(context, '/home')),

//           const SizedBox(height: 20),
//           const Text("OR", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),

//           // Mock Google Button
//           _buildGoogleButton(),

//           const SizedBox(height: 40),
          
//           // Toggle Link
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
//               GestureDetector(
//                 onTap: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
//                 child: const Text("Register now", style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold, fontSize: 12)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // --- SIGN UP UI (Screenshot 11.31.04) ---
//   Widget _buildSignUpPage() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB74D)),
//             onPressed: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
//           ),
//           const SizedBox(height: 20),
//           const Text("Join CEM", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
//           const Text("Create your IITJ Marketplace identity.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          
//           const SizedBox(height: 40),

//           _buildInputCard(title: "IITJ EMAIL", hint: "roll_no@iitj.ac.in", icon: Icons.email),
//           const SizedBox(height: 20),
          
//           // Hostel Dropdown
//           const Text("HOSTEL", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 18),
//             decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: "Brahmaputra",
//                 dropdownColor: const Color(0xFF0A1128),
//                 isExpanded: true,
//                 items: ["Brahmaputra", "Luni", "Kshipra"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(),
//                 onChanged: (v) {},
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),
//           _buildInputCard(title: "SET PASSWORD", hint: "••••••••", icon: null, isPassword: true),

//           const SizedBox(height: 40),
//           _buildPrimaryButton("CREATE MY ACCOUNT", onTap: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
//         ],
//       ),
//     );
//   }

//   // --- SHARED UI HELPERS ---
//   Widget _buildInputCard({required String title, required String hint, IconData? icon, bool isPassword = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 18),
//           decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
//           child: TextField(
//             obscureText: isPassword,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               icon: icon != null ? Icon(icon, color: const Color(0xFFFFB74D), size: 20) : null,
//               hintText: hint,
//               hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPrimaryButton(String text, {required VoidCallback onTap}) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFFF8C00),
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         ),
//         child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
//       ),
//     );
//   }

//   Widget _buildGoogleButton() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 18),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.g_mobiledata, color: Colors.black, size: 30),
//           SizedBox(width: 10),
//           Text("Continue with Google", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }