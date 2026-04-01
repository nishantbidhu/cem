import 'package:flutter/material.dart';
class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color(0xFF0A1128),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "For assistance, please contact us at support@example.com"
          ),
      ),
    );
  }
}