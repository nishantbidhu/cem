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
          "For assistance, please contact us at support@example.com or call the helpline at +91-800-123-4567.\n"
          "If you have any questions or need help with the app, our support team is here to assist you.\n\n"
          "If you notice unauthorized activity on any account or listing, please report it immediately to our support team.\n\n"
          "Those activities include but are not limited to:\n"
          "- Posting fraudulent or stolen listings\n"
          "- Posting inappropriate or illegal content\n"
          "- Leaking personal information of other users\n"
          "- Harassing or threatening other users\n\n"
          "We remind users that the only acounts allowed on the app are the ones created with IITJ email ID.\n"
          "If your account is removed due to violation of our policies, the creation of a new account will not be permitted.\n"
          "If your account get suspended by mistake, please contact us immediately to resolve the issue.",
        ),
      ),
    );
  }
}