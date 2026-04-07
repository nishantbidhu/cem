import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Call this function to pop up the floating window!
void showNotificationsPopup(BuildContext context) {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xFF1A212E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 20,
      // The window will take up 60% of the screen height and float in the middle
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6, 
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications, color: Color(0xFFFFB74D)),
                    SizedBox(width: 10),
                    Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 30),
            
            // --- NOTIFICATION LIST ---
            Expanded(
              child: currentUserId == null
                  ? const Center(child: Text("Please log in.", style: TextStyle(color: Colors.white)))
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('notifications')
                          .where('userId', isEqualTo: currentUserId)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Center(child: Text("Waiting for Firebase Index...", style: const TextStyle(color: Color(0xFF94A3B8))));
                        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));

                        final docs = snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_off_outlined, color: Colors.white24, size: 60),
                                SizedBox(height: 16),
                                Text("No notifications yet", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final bool isRead = data['isRead'] ?? false;
                            
                            return GestureDetector(
                              onTap: () {
                                if (!isRead) {
                                  FirebaseFirestore.instance.collection('notifications').doc(docs[index].id).update({'isRead': true});
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isRead ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isRead ? Colors.transparent : const Color(0xFFFFB74D).withOpacity(0.3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: const Color(0xFFFF8C00).withOpacity(0.2), shape: BoxShape.circle),
                                      child: const Icon(Icons.bolt, color: Color(0xFFFFB74D), size: 16),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data['title'] ?? 'Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isRead ? Colors.white70 : Colors.white)),
                                          const SizedBox(height: 4),
                                          Text(data['body'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                        ],
                                      ),
                                    ),
                                    if (!isRead)
                                      Container(margin: const EdgeInsets.only(top: 4), width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFF8C00), shape: BoxShape.circle)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}