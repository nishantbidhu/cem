import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/listing_service.dart';
import '../domain/listing_model.dart';
import 'listing_detail_screen.dart';
import 'notifications_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final ListingService service = ListingService();
  
  // STATE VARIABLES FOR FILTERING
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ["All", "Bicycles", "Tech/Electronics", "Books/Notes", "Lab Gear", "Others"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(context), 
        _buildSearchBar(),
        _buildCategories(),
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFFFFB74D),
            backgroundColor: const Color(0xFF0F172A),
            onRefresh: () async {
              setState(() {}); // Triggers the FutureBuilder to run again
            },
            child: FutureBuilder<List<Listing>>(
              future: service.getSaleListingsFuture(), // USING THE FUTURE NOW
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));
                
                final listings = snapshot.data!.where((item) {
                  final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
                  final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList();

                if (listings.isEmpty) {
                  return ListView( // Needs to be scrollable for RefreshIndicator to work
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text("No items match your search.", style: TextStyle(color: Color(0xFF94A3B8)))),
                    ]
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: listings.length,
                  itemBuilder: (context, index) => _buildListingCard(context, listings[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        height: 50, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
        child: Center(
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value), // UPDATES STATE
            textAlignVertical: TextAlignVertical.center, 
            style: const TextStyle(color: Colors.white, fontSize: 14), 
            decoration: const InputDecoration(hintText: "Search gear...", hintStyle: TextStyle(color: Color(0xFF94A3B8)), border: InputBorder.none, prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20))
          )
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 45, margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 24), itemCount: _categories.length,
        itemBuilder: (context, i) {
          final isSelected = _categories[i] == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[i]), // UPDATES STATE
            child: Container(
              margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFFFFB74D) : Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? Colors.transparent : Colors.white10)),
              child: Center(child: Text(_categories[i], style: TextStyle(color: isSelected ? Colors.black : const Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12))),
            ),
          );
        },
      ),
    );
  }

  // --- UPDATED Helpers for UI (Handshake logic fixed with FLOATING SnackBars) ---
  void _showVerificationSheet(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xFFFFB74D), size: 40),
          const SizedBox(height: 15),
          const Text("VERIFY EXCHANGE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
          const Text("Enter the 6-digit code from the seller.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 25),
          Container(padding: const EdgeInsets.symmetric(horizontal: 18), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)), child: TextField(controller: codeController, textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 6, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8, color: Color(0xFFFFB74D)), decoration: const InputDecoration(counterText: "", border: InputBorder.none, hintText: "000000"))),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity, 
            child: ElevatedButton(
              onPressed: () async {
                String? buyerId = FirebaseAuth.instance.currentUser?.uid;
                if (buyerId != null) {
                  // Hide keyboard so SnackBar is clearly visible
                  FocusScope.of(context).unfocus(); 
                  
                  bool success = await service.completeTransactionByCode(codeController.text, buyerId);
                  
                  if (context.mounted) { 
                    if (success) {
                      Navigator.pop(context); // Close the sheet ONLY on success
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Purchase Verified! Item marked as Sold.", style: TextStyle(color: Colors.white)), 
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 90, left: 20, right: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        )
                      ); 
                    } else {
                      // Keep sheet open and show polite floating error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Incorrect 6-digit code. Please verify with the seller.", style: TextStyle(color: Colors.white)), 
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 90, left: 20, right: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        )
                      );
                    }
                  }
                }
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00), padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), 
              child: const Text("CONFIRM PURCHASE", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white))
            )
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) { 
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(text: const TextSpan(style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white), children: [TextSpan(text: "CEM"), TextSpan(text: "."), TextSpan(text: "IITJ", style: TextStyle(color: Color(0xFFFFB74D)))])),
          Row(
            children: [
              _buildActionBtn(Icons.qr_code_scanner, onTap: () => _showVerificationSheet(context)), 
              // --- NEW: WIRED UP THE BELL ICON ---
              _buildActionBtn(Icons.notifications, onTap: () => showNotificationsPopup(context)),
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(left: 12), width: 42, height: 42, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)), child: Icon(icon, color: const Color(0xFFFFB74D), size: 20)));
  }

  Widget _buildListingCard(BuildContext context, Listing item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListingDetailScreen(item: item))),
      child: Container(
        height: 110, margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Row(children: [
          Container(width: 100, decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))), child: Icon(item.isSeeking ? Icons.person_search : Icons.directions_bike, color: const Color(0xFFFFB74D), size: 28)),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              Text(item.priceText, style: const TextStyle(color: Color(0xFFFFB74D), fontSize: 19, fontWeight: FontWeight.w800)),
              Text("${item.location} • ${item.condition}", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
            ]),
          ),
        ]),
      ),
    );
  }
}