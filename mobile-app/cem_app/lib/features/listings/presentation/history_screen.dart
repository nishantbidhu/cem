import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/listing_service.dart';
import '../domain/listing_model.dart';
import 'notifications_popup.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isBoughtTab = true; 
  final ListingService _service = ListingService();
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (_uid == null) return const Center(child: Text("Please Log In"));

    return Column(
      children: [
        _buildAppBar(context),
        _buildToggleButton(),
        Expanded(
          child: StreamBuilder<List<Listing>>(
            stream: isBoughtTab 
                ? _service.getBoughtHistory(_uid!) 
                : _service.getSoldHistory(_uid!),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)));
              
              final items = snapshot.data!;
              if (items.isEmpty) return const Center(child: Text("No transaction history found.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)));
              
              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: items.length,
                itemBuilder: (context, index) => _buildHistoryCard(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(Listing item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Row(children: [
          // --- FIX IS HERE: ADDED IMAGE LOGIC ---
          Container(
            width: 60, 
            height: 60, 
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), 
              borderRadius: BorderRadius.circular(16),
              image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ), 
            child: item.imageUrl == null || item.imageUrl!.isEmpty
                ? Icon(item.isSeeking ? Icons.person_search : Icons.directions_bike, color: const Color(0xFFFFB74D), size: 28)
                : null,
          ),
          // --- END OF FIX ---
          
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 4),
                Text(isBoughtTab ? "EXCHANGED" : "SOLD", style: const TextStyle(fontSize: 10, color: Color(0xFFFFB74D), fontWeight: FontWeight.bold)),
                const Text("DATE: JUST NOW", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ])),
          Text(item.priceText, style: const TextStyle(color: Color(0xFFFFB74D), fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          RichText(text: const TextSpan(style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white), children: [TextSpan(text: "CEM"), TextSpan(text: ".", style: TextStyle(color: Color(0xFFFFB74D))), TextSpan(text: "HISTORY")])),
          Row(
            children: [
              _buildActionBtn(Icons.qr_code_scanner, onTap: () => _showVerificationSheet(context)), 
              _buildActionBtn(Icons.notifications, onTap: () => showNotificationsPopup(context))
            ]
          ),
      ]),
    );
  }

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
          const Text("Enter the 6-digit code shown on the seller's screen.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 25),
          Container(padding: const EdgeInsets.symmetric(horizontal: 18), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)), child: TextField(controller: codeController, textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 6, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8, color: Color(0xFFFFB74D)), decoration: const InputDecoration(counterText: "", border: InputBorder.none, hintText: "000000"))),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async {
            if (_uid != null) {
              bool success = await _service.completeTransactionByCode(codeController.text, _uid!);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? "Verified!" : "Error"), backgroundColor: success ? Colors.green : Colors.redAccent));
              }
            }
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00), padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), child: const Text("CONFIRM PURCHASE", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)))),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, {VoidCallback? onTap}) { return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(left: 12), width: 42, height: 42, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)), child: Icon(icon, color: const Color(0xFFFFB74D), size: 20))); }
  Widget _buildToggleButton() { return Container(margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), height: 55, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)), child: Row(children: [_buildTabItem("BOUGHT", isBoughtTab, () => setState(() => isBoughtTab = true)), _buildTabItem("SOLD", !isBoughtTab, () => setState(() => isBoughtTab = false))])); }
  Widget _buildTabItem(String label, bool isActive, VoidCallback onTap) { return Expanded(child: GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: isActive ? const Color(0xFFFFB74D) : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(label, style: TextStyle(color: isActive ? Colors.black : const Color(0xFF94A3B8), fontWeight: FontWeight.w900, fontSize: 13)))))); }
}