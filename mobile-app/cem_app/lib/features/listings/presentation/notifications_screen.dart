import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFB74D), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)),
      ),
      body: currentUserId == null
          ? const Center(child: Text("Please log in.", style: TextStyle(color: Colors.white)))
          : StreamBuilder<QuerySnapshot>(
              // Query: Get notifications for THIS user, ordered by newest first
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: currentUserId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.redAccent)));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, color: Colors.white24, size: 60),
                        SizedBox(height: 16),
                        Text("No notifications yet", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final bool isRead = data['isRead'] ?? false;
                    
                    return GestureDetector(
                      onTap: () {
                        // Mark as read when tapped
                        if (!isRead) {
                          FirebaseFirestore.instance.collection('notifications').doc(docs[index].id).update({'isRead': true});
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isRead ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isRead ? Colors.transparent : const Color(0xFFFFB74D).withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: const Color(0xFFFF8C00).withOpacity(0.2), shape: BoxShape.circle),
                              child: const Icon(Icons.notifications_active, color: Color(0xFFFFB74D), size: 18),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['title'] ?? 'Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isRead ? Colors.white70 : Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(data['body'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                                ],
                              ),
                            ),
                            if (!isRead)
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFF8C00), shape: BoxShape.circle)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}