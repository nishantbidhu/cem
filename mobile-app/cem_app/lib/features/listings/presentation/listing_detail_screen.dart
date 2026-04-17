import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/listing_model.dart';
import 'package:flutter/services.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing item;

  const ListingDetailScreen({super.key, required this.item});

  void _showReportDialog(BuildContext context) {
    String selectedReason = 'Suspected Scam';
    final TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A212E),
            title: const Text("Report Listing", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Reason for reporting:", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                const SizedBox(height: 8),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                    child: DropdownButton<String>(
                      value: selectedReason,
                      dropdownColor: const Color(0xFF0A1128),
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFB74D)),
                      items: ['Suspected Scam', 'Inappropriate Content', 'Fake Item', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => selectedReason = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: detailsController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Additional details...",
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Color(0xFF94A3B8)))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () async {
                // 1. Write the report to Firestore FIRST
                await FirebaseFirestore.instance.collection('reports').add({
                  'listingId': item.id,
                  'listingTitle': item.title,
                  'reason': selectedReason,
                  'details': detailsController.text,
                  'reportedAt': FieldValue.serverTimestamp(),
                  'sellerId': item.sellerId,
                  'status': 'pending', // Good for admin review tracking
                });

                // 2. Then trigger the email to the Admin
                final String subject = Uri.encodeComponent("Report: Listing ${item.id}");
                final String body = Uri.encodeComponent("Listing Title: ${item.title}\nReport Reason: $selectedReason\nDetails: ${detailsController.text}");
                final Uri emailUri = Uri.parse("mailto:cemiitjtest@gmail.com?subject=$subject&body=$body");
                
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                }
                if (context.mounted) Navigator.pop(context);
              },
                child: const Text("SUBMIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(item.sellerId).get(),
        builder: (context, snapshot) {
          
          Map<String, dynamic>? sellerData;
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.exists) {
            sellerData = snapshot.data!.data() as Map<String, dynamic>?;
          }

          final String sellerEmail = sellerData?['email'] ?? "cemiitjtest@gmail.com";
          final String sellerHostel = sellerData?['hostel'] ?? item.location;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- UPDATED: HERO IMAGE ---
                    _buildHeroImage(),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.priceText, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D))),
                          Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          
                          const SizedBox(height: 25),

                          _buildSellerCard(sellerData),

                          const SizedBox(height: 25),

                          _buildDataGrid(sellerHostel),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("DESCRIPTION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final uid = FirebaseAuth.instance.currentUser?.uid;
                                      if (uid == null) return;
                                      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                                      if (userDoc.data()?['role'] == 'admin') {
                                        await FirebaseFirestore.instance.collection('listings').doc(item.id).delete();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post deleted by Admin"), backgroundColor: Colors.red));
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Admin privileges required")));
                                        }
                                      }
                                    },
                                    child: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 20),
                                  ),
                                  const SizedBox(width: 15),
                                  _buildReportButton(context),
                                ],
                              ),
                            ], 
                          ),
                          const SizedBox(height: 12),
                          Text(item.description, 
                            style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.5)),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- UPDATED: MEDIA QUERY FIX FOR NOTCH ---
              Positioned(
                top: MediaQuery.of(context).padding.top + 10, left: 20,
                child: _buildBackButton(context),
              ),

              // --- UPDATED: MEDIA QUERY FIX FOR BOTTOM SWIPE BAR ---
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 15, left: 24, right: 24,
                child: _buildInterestBar(context, sellerEmail), 
              ),
            ],
          );
        }
      ),
    );
  }

  // --- REWRITTEN: HANDLES FIREBASE STORAGE IMAGES OR FALLBACK ICONS ---
  Widget _buildHeroImage() {
    return Container(
      height: 350, 
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        image: item.imageUrl != null && item.imageUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(item.imageUrl!),
                fit: BoxFit.cover, // Ensures the photo elegantly fills the container
              )
            : null,
      ),
      child: item.imageUrl == null || item.imageUrl!.isEmpty
          ? Center(
              child: Icon(item.isSeeking ? Icons.person_search : Icons.directions_bike, size: 100, color: const Color(0xFFFFB74D).withOpacity(0.2)),
            )
          : null, // Don't show the icon if an image exists
    );
  }

  Widget _buildSellerCard(Map<String, dynamic>? sellerData) {
    final String sellerName = sellerData?['name'] ?? 'Loading...';
    final String sellerEmail = sellerData?['email'] ?? 'Loading...';
    final String sellerPhone = sellerData?['phone'] ?? 'Loading...';
    final String initial = (sellerName != 'Loading...' && sellerName.isNotEmpty) ? sellerName[0].toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 55, height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
            ),
            child: Center(child: Text(initial, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D)))),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                Text(sellerEmail, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                Text(sellerPhone, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
        ],
      ),
    );
  }

  Widget _buildDataGrid(String sellerHostel) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildInfoTile("CONDITION", item.condition),
        _buildInfoTile("TYPE", item.isSeeking ? "Request" : "Purchase"), 
        _buildInfoTile("HOSTEL", sellerHostel), 
        _buildInfoTile("CATEGORY", item.category),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // --- UPDATED: REMOVED THE HEART/SAVE ICON COMPLETELY ---
  Widget _buildInterestBar(BuildContext context, String sellerEmail) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final String subject = Uri.encodeComponent("CEM Inquiry: ${item.title}");
          
          final String body = Uri.encodeComponent(
            "Hi,\n\n"
            "I am interested in your listing for the '${item.title}' (listed at ${item.priceText}) on the CEM app.\n\n"
            "I would like to check it out. Please let me know your availability and a convenient place to meet on campus.\n\n"
            "Thanks!"
          );

          final Uri emailUri = Uri.parse("mailto:$sellerEmail?subject=$subject&body=$body");
          
          if (await canLaunchUrl(emailUri)) {
            await launchUrl(emailUri);
          } else {
            // Execute the R4 Mitigation: Copy to clipboard
            await Clipboard.setData(ClipboardData(text: sellerEmail));
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Email client failed. Address copied to clipboard!"), 
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 4),
                )
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8C00),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10, shadowColor: const Color(0xFFFF8C00).withOpacity(0.3),
        ),
        child: const Text("I'M INTERESTED", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white)),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReportDialog(context),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.redAccent, size: 14),
          const SizedBox(width: 5),
          Text("REPORT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.redAccent.withOpacity(0.8), letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF0A1128).withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFB74D), size: 20),
      ),
    );
  }
}