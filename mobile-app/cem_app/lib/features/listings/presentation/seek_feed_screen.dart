




import 'package:flutter/material.dart';
import '../data/listing_service.dart';
import '../domain/listing_model.dart';
import 'listing_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeekFeedScreen extends StatelessWidget {
  const SeekFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ListingService service = ListingService();

    return Column(
      children: [
        _buildAppBar(context, service), 
        _buildSearchSection(),
        Expanded(
          child: StreamBuilder<List<Listing>>(
            stream: service.getSeekListings(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));
              final listings = snapshot.data!;
              if (listings.isEmpty) return const Center(child: Text("No seek requests found.", style: TextStyle(color: Color(0xFF94A3B8))));

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: listings.length,
                itemBuilder: (context, index) => _buildSeekCard(context, listings[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeekCard(BuildContext context, Listing item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFFFB74D))),
          const SizedBox(height: 5),
          Text("${item.priceText} MAX BUDGET", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFFFF8C00)),
              const SizedBox(width: 5),
              Text(item.location, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListingDetailScreen(item: item))),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12)
              ),
              child: const Text("I HAVE THIS ITEM", style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showVerificationSheet(BuildContext context, ListingService service) {
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
          const Text("Enter the code from the provider's screen.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 25),
          Container(padding: const EdgeInsets.symmetric(horizontal: 18), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)), child: TextField(controller: codeController, textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 6, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8, color: Color(0xFFFFB74D)), decoration: const InputDecoration(counterText: "", border: InputBorder.none, hintText: "000000"))),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async {
            // FIX: Retrieve real UID
            String? currentUid = FirebaseAuth.instance.currentUser?.uid;
            
            if (currentUid != null) {
              bool success = await service.completeTransactionByCode(codeController.text, currentUid);
              if (context.mounted) { 
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? "Verified!" : "Error"), backgroundColor: success ? Colors.green : Colors.redAccent)); 
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Not logged in"), backgroundColor: Colors.redAccent));
            }
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00), padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), child: const Text("CONFIRM EXCHANGE", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)))),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ListingService service) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(text: const TextSpan(style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white), children: [TextSpan(text: "SEEK"), TextSpan(text: "."), TextSpan(text: "FEED", style: TextStyle(color: Color(0xFFFFB74D)))])),
          Row(children: [_buildActionBtn(Icons.qr_code_scanner, onTap: () => _showVerificationSheet(context, service)), _buildActionBtn(Icons.notifications)]),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, {VoidCallback? onTap}) { return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(left: 12), width: 42, height: 42, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)), child: Icon(icon, color: const Color(0xFFFFB74D), size: 20))); }
  Widget _buildSearchSection() { return Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), child: Container(height: 50, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)), child: const Center(child: TextField(textAlignVertical: TextAlignVertical.center, style: TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: "Search requests...", hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14), border: InputBorder.none, prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20)))))); }
}