
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'update_profile_screen.dart'; 
import '../../listings/presentation/my_listings_screen.dart';
import '../../listings/data/listing_service.dart';
import 'help_and_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Center(child: Text("Please Log In", style: TextStyle(color: Colors.white)));

    // --- WRAPPED IN A STREAMBUILDER TO FETCH REAL USER DATA ---
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error loading profile"));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));

        // Safely extract the data
        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final String userName = userData?['name'] ?? 'Student Account';
        final String userPhone = userData?['phone'] ?? '+91 00000 00000'; // <-- GRAB THE PHONE
        final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildUserAvatar(initial), 
              const SizedBox(height: 20),
              
              // Dynamic Name
              Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
              const Text("VERIFIED", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFB74D), letterSpacing: 1)),
              
              Text(user.email?.toUpperCase() ?? "MAIL@IITJ.AC.IN", 
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
              
              // --- NEW: DISPLAY THE PHONE NUMBER ---
              const SizedBox(height: 4),
              Text(userPhone, 
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
              // -------------------------------------

              const SizedBox(height: 30),
              _buildStatsRow(), 
              const SizedBox(height: 40),

              _buildMenuTile(
                Icons.person_outline, 
                "Update Profile", 
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen())),
              ),
              _buildMenuTile(
                Icons.inventory_2_outlined, 
                "My Listings",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyListingsScreen())),
              ),
              _buildMenuTile(Icons.help_outline, "Help & Support",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpAndSupportScreen())),
              ),
              _buildMenuTile(Icons.chat_bubble_outline, "Send App Feedback"),
              
              const SizedBox(height: 10),
              _buildLogoutTile(context),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  bool? confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1A212E),
                      title: const Text("Delete Account?", style: TextStyle(color: Colors.white)),
                      content: const Text("This will permanently erase your profile and active listings. This cannot be undone.", style: TextStyle(color: Colors.white54)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                            await user.delete();
                            if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                          }, 
                          child: const Text("DELETE FOREVER", style: TextStyle(color: Colors.redAccent))
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("Delete My Account", style: TextStyle(color: Colors.redAccent, fontSize: 12, decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }
    );
  }

  Widget _buildMenuTile(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Row(children: [
            Icon(icon, color: const Color(0xFFFFB74D), size: 22),
            const SizedBox(width: 15),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
        ]),
      ),
    );
  }

  Widget _buildUserAvatar(String initial) {
    return Container(
      width: 100, height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFFFFB74D), width: 2)),
      child: Center(child: Text(initial, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D)))),
    );
  }

  Widget _buildStatsRow() {
    final ListingService service = ListingService();
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const SizedBox();

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        StreamBuilder(
          stream: service.getSoldHistory(uid),
          builder: (context, snapshot) {
            String count = snapshot.hasData ? snapshot.data!.length.toString().padLeft(2, '0') : "00";
            return _buildStatItem(count, "SOLD");
          }
        ),
        
        Container(width: 1, height: 30, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 30)),
        
        StreamBuilder(
          stream: service.getBoughtHistory(uid),
          builder: (context, snapshot) {
            String count = snapshot.hasData ? snapshot.data!.length.toString().padLeft(2, '0') : "00";
            return _buildStatItem(count, "BOUGHT");
          }
        ),
    ]);
  }

  Widget _buildStatItem(String count, String label) {
    return Column(children: [
        Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
    ]);
  }

  Widget _buildLogoutTile(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.red.withOpacity(0.1))),
        child: const Row(children: [
            Icon(Icons.power_settings_new, color: Colors.redAccent, size: 22),
            SizedBox(width: 15),
            Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent)),
        ]),
      ),
    );
  }
}