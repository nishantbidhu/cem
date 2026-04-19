import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryDark = Color.fromARGB(255, 46, 45, 45);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(color: Colors.white)),
        
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Contact Header
            const Text(
              "Need Assistance?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 248, 245, 245)),
            ),
            const SizedBox(height: 8),
            Text(
              "Our support team is here to help you with any questions regarding the app.",
              style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 199, 197, 197)),
            ),
            const SizedBox(height: 20),

            // 2. Contact Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 32, 32),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 192, 192, 192)!),
              ),
              child: Column(
                children: [
                  _buildStaticContactRow(Icons.email_outlined, "cemiitjtest@gmail.com"),
                  const Divider(height: 24),
                  _buildStaticContactRow(Icons.phone_android_outlined, "+91-800-123-4567"),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 3. Reporting Section
            const Text(
              "Reporting Misconduct",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 12),
            _buildPolicyCard([
              "Fraudulent or stolen listings",
              "Inappropriate or illegal content",
              "Leaking personal information",
              "Harassing or threatening users",
            ]),
            const SizedBox(height: 32),

            // 4. Important Reminders
            const Text(
              "Important Reminders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 12),
            _buildInfoNote(
              "Accounts must be created using a valid IITJ email ID. Policy violations resulting in removal are permanent, and new account creation will not be permitted."
            ),
            const SizedBox(height: 12),
            _buildInfoNote(
              "If you believe your account was suspended by mistake, please reach out to us immediately for resolution."
            ),
          ],
        ),
      ),
    );
  }

  // Helper for contact rows (No interaction)
  Widget _buildStaticContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 255, 255, 255), size: 22),
        const SizedBox(width: 16),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Helper for the bulleted policy card
  Widget _buildPolicyCard(List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5), // Light red tint for warnings
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              Expanded(child: Text(item, style: const TextStyle(color: Colors.black87))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  // Helper for general info notes
  Widget _buildInfoNote(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.blue[900], height: 1.4),
      ),
    );
  }
}



