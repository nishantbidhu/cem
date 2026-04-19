import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/listing_service.dart';
import '../domain/listing_model.dart';
import 'pages/creation_form_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ListingService service = ListingService();
    final String? _uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFB74D), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Listings", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
      ),
      body: _uid == null 
        ? const Center(child: Text("Please Log In", style: TextStyle(color: Colors.white)))
        : StreamBuilder<List<Listing>>(
            stream: service.getUserListings(_uid), 
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));
              
              final listings = snapshot.data!;
              if (listings.isEmpty) return _buildEmptyState();

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: listings.length,
                itemBuilder: (context, index) => _buildManageableCard(context, listings[index]),
              );
            },
          ),
    );
  }

  void _showVerificationCode(BuildContext context, Listing item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A212E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("EXCHANGE CODE", 
            style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Provide this code to the buyer to verify the physical exchange.", 
                textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
              child: Text(
                item.transactionCode ?? "------", 
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageableCard(BuildContext context, Listing item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // --- FIX IS HERE: ADDED IMAGE LOGIC ---
          Container(
            width: 70, 
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03), 
              borderRadius: BorderRadius.circular(16),
              image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.imageUrl == null || item.imageUrl!.isEmpty
                ? Icon(item.isSeeking ? Icons.person_search : Icons.directions_bike, color: const Color(0xFFFFB74D), size: 24)
                : null,
          ),
          // --- END OF FIX ---
          
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.priceText, style: const TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.w900, fontSize: 18)),
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const Text("• ACTIVE POSTING", style: TextStyle(color: Color(0xFF4CAF50), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CreationFormScreen(
                            isSalePost: !item.isSeeking, 
                            existingListing: item,
                          )
                        ));
                      },
                      child: const Icon(Icons.edit_note_outlined, color: Colors.white60, size: 20),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF1A212E),
                            title: const Text("Delete Listing?", style: TextStyle(color: Colors.white)),
                            content: const Text("This action cannot be undone.", style: TextStyle(color: Colors.white54)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("DELETE", style: TextStyle(color: Colors.redAccent))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ListingService().deleteListing(item.id);
                        }
                      },
                      child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showVerificationCode(context, item),
            child: Container(
              width: 55, height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: const Color(0xFFFFB74D).withOpacity(0.2), blurRadius: 15)],
              ),
              child: const Icon(Icons.vpn_key_rounded, color: Colors.black, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(30)),
            child: const Icon(Icons.inventory_2_outlined, size: 60, color: Color(0xFFFFB74D)),
          ),
          const SizedBox(height: 25),
          const Text("No active listings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        ],
      ),
    );
  }
}