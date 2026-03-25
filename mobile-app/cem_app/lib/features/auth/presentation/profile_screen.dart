// import 'package:flutter/material.dart';
// import 'update_profile_screen.dart'; // Ensure this import is present
// import '../../listings/presentation/my_listings_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         children: [
//           const SizedBox(height: 60),
//           _buildUserAvatar(),
//           const SizedBox(height: 20),
//           const Text("User Name", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
//           const Text("HOSTEL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFB74D), letterSpacing: 1)),
//           const Text("MAIL@IITJ.AC.IN", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
//           const Text("+91 91101 XXXXX", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
          
//           const SizedBox(height: 30),
//           _buildStatsRow(),
//           const SizedBox(height: 40),

//           // --- FIXED MENU TILES ---
//           _buildMenuTile(
//             Icons.person_outline, 
//             "Update Profile", 
//             onTap: () => Navigator.push(
//               context, 
//               MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
//             ),
//           ),
//           _buildMenuTile(
//             Icons.inventory_2_outlined, 
//             "My Listings",
//             onTap: () => Navigator.push(
//               context, 
//               MaterialPageRoute(builder: (context) => const MyListingsScreen())
//             ),
//           ),
//           _buildMenuTile(Icons.help_outline, "Help & Support"),
//           _buildMenuTile(Icons.chat_bubble_outline, "Send App Feedback"),
          
//           const SizedBox(height: 10),
//           _buildLogoutTile(),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   // UPDATED HELPER: Added 'onTap' parameter to fix the error
//   Widget _buildMenuTile(IconData icon, String title, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.05)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: const Color(0xFFFFB74D), size: 22),
//             const SizedBox(width: 15),
//             Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
//             const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
//           ],
//         ),
//       ),
//     );
//   }

//   // ... rest of your UI helpers (_buildUserAvatar, _buildStatsRow, etc.)
//   Widget _buildUserAvatar() {
//     return Container(
//       width: 100, height: 100,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: const Color(0xFFFFB74D), width: 2),
//       ),
//       child: const Center(
//         child: Text("U", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D))),
//       ),
//     );
//   }

//   Widget _buildStatsRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildStatItem("08", "SOLD"),
//         Container(width: 1, height: 30, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 30)),
//         _buildStatItem("14", "BOUGHT"),
//       ],
//     );
//   }

//   Widget _buildStatItem(String count, String label) {
//     return Column(
//       children: [
//         Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
//       ],
//     );
//   }

//   Widget _buildLogoutTile() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.red.withOpacity(0.1)),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.power_settings_new, color: Colors.redAccent, size: 22),
//           const SizedBox(width: 15),
//           Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent)),
//         ],
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'update_profile_screen.dart'; 
// import '../../listings/presentation/my_listings_screen.dart';
// import '../../listings/data/listing_service.dart';


// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // SYNC: Pull real email from mock account
//     final user = FirebaseAuth.instance.currentUser;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         children: [
//           const SizedBox(height: 60),
//           _buildUserAvatar(),
//           const SizedBox(height: 20),
//           const Text("User Name", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
//           const Text("HOSTEL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFB74D), letterSpacing: 1)),
          
//           // DISPLAY REAL MOCK EMAIL
//           Text(user?.email?.toUpperCase() ?? "MAIL@IITJ.AC.IN", 
//             style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
//           const Text("+91 91101 XXXXX", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
          
//           const SizedBox(height: 30),
//           _buildStatsRow(),
//           const SizedBox(height: 40),

//           _buildMenuTile(
//             Icons.person_outline, 
//             "Update Profile", 
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen())),
//           ),
//           _buildMenuTile(
//             Icons.inventory_2_outlined, 
//             "My Listings",
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyListingsScreen())),
//           ),
//           _buildMenuTile(Icons.help_outline, "Help & Support"),
//           _buildMenuTile(Icons.chat_bubble_outline, "Send App Feedback"),
          
//           const SizedBox(height: 10),
          
//           // FUNCTIONAL LOGOUT
//           _buildLogoutTile(context),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuTile(IconData icon, String title, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
//         child: Row(children: [
//             Icon(icon, color: const Color(0xFFFFB74D), size: 22),
//             const SizedBox(width: 15),
//             Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
//             const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
//         ]),
//       ),
//     );
//   }

//   Widget _buildUserAvatar() {
//     return Container(
//       width: 100, height: 100,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFFFFB74D), width: 2)),
//       child: const Center(child: Text("U", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D)))),
//     );
//   }

//   Widget _buildStatsRow() {
//     final ListingService service = ListingService();
//     final String? uid = FirebaseAuth.instance.currentUser?.uid;

//     if (uid == null) return const SizedBox();

//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         // SOLD STREAM
//         StreamBuilder(
//           stream: service.getSoldHistory(uid),
//           builder: (context, snapshot) {
//             String count = snapshot.hasData ? snapshot.data!.length.toString().padLeft(2, '0') : "--";
//             return _buildStatItem(count, "SOLD");
//           }
//         ),
        
//         Container(width: 1, height: 30, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 30)),
        
//         // BOUGHT STREAM
//         StreamBuilder(
//           stream: service.getBoughtHistory(uid),
//           builder: (context, snapshot) {
//             String count = snapshot.hasData ? snapshot.data!.length.toString().padLeft(2, '0') : "--";
//             return _buildStatItem(count, "BOUGHT");
//           }
//         ),
//     ]);
//   }

//   Widget _buildStatItem(String count, String label) {
//     return Column(children: [
//         Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
//     ]);
//   }

//   Widget _buildLogoutTile(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         await FirebaseAuth.instance.signOut();
//         if (context.mounted) {
//           Navigator.pushReplacementNamed(context, '/login');
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.red.withOpacity(0.1))),
//         child: const Row(children: [
//             Icon(Icons.power_settings_new, color: Colors.redAccent, size: 22),
//             SizedBox(width: 15),
//             Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent)),
//         ]),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'update_profile_screen.dart'; 
import '../../listings/presentation/my_listings_screen.dart';
import '../../listings/data/listing_service.dart'; // ADDED IMPORT

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          _buildUserAvatar(),
          const SizedBox(height: 20),
          const Text("Student Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
          const Text("VERIFIED", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFB74D), letterSpacing: 1)),
          
          Text(user?.email?.toUpperCase() ?? "MAIL@IITJ.AC.IN", 
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
          
          const SizedBox(height: 30),
          _buildStatsRow(), // NOW DYNAMIC
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
          _buildMenuTile(Icons.help_outline, "Help & Support"),
          _buildMenuTile(Icons.chat_bubble_outline, "Send App Feedback"),
          
          const SizedBox(height: 10),
          _buildLogoutTile(context),
          const SizedBox(height: 100),
        ],
      ),
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

  Widget _buildUserAvatar() {
    return Container(
      width: 100, height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFFFFB74D), width: 2)),
      child: const Center(child: Text("U", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D)))),
    );
  }

  // --- UPDATED: DYNAMIC STATS ROW ---
  Widget _buildStatsRow() {
    final ListingService service = ListingService();
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const SizedBox();

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // SOLD STREAM
        StreamBuilder(
          stream: service.getSoldHistory(uid),
          builder: (context, snapshot) {
            String count = snapshot.hasData ? snapshot.data!.length.toString().padLeft(2, '0') : "00";
            return _buildStatItem(count, "SOLD");
          }
        ),
        
        Container(width: 1, height: 30, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 30)),
        
        // BOUGHT STREAM
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