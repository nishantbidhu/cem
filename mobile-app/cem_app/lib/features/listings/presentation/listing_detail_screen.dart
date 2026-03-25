import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/listing_model.dart';

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
      backgroundColor: const Color(0xFF0A1128), // Navy Deep
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. IMAGE PLACEHOLDER SECTION ---
                _buildHeroImage(),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- PRICE & TITLE ---
                      Text(item.priceText, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D))),
                      Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      
                      const SizedBox(height: 25),

                      // --- 2. SELLER IDENTITY CARD ---
                      _buildSellerCard(),

                      const SizedBox(height: 25),

                      // --- 3. DATA GRID (Condition, Age, Hostel, Category) ---
                      _buildDataGrid(),

                      const SizedBox(height: 30),

                      // --- DESCRIPTION & REPORT ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("DESCRIPTION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                          _buildReportButton(context),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(item.description, 
                        style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.5)),

                      const SizedBox(height: 120), // Bottom padding for FAB
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back Button Overlay
          Positioned(
            top: 50, left: 20,
            child: _buildBackButton(context),
          ),

          // --- 4. BOTTOM ACTION BAR ---
          Positioned(
            bottom: 30, left: 24, right: 24,
            child: _buildInterestBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 350, width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Center(
        child: Icon(item.isSeeking ? Icons.person_search : Icons.directions_bike, size: 100, color: const Color(0xFFFFB74D).withOpacity(0.2)),
      ),
    );
  }

  Widget _buildSellerCard() {
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
            child: const Center(child: Text("U", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D)))),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                Text("user.1@iitj.ac.in", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                Text("+91 91101 XXXXX", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
        ],
      ),
    );
  }

  Widget _buildDataGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildInfoTile("CONDITION", item.condition),
        _buildInfoTile("AGE", "1.5 Years"), // Placeholder for now
        _buildInfoTile("HOSTEL", item.location),
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

  Widget _buildInterestBar() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {}, // Email Logic to be added later
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C00),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10, shadowColor: const Color(0xFFFF8C00).withOpacity(0.3),
            ),
            child: const Text("I'M INTERESTED", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white)),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.favorite_border, color: Color(0xFFFFB74D)),
        ),
      ],
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