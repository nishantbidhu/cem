// import 'package:flutter/material.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   bool isBoughtTab = true; 

//   // --- 1. VERIFICATION LOGIC ---
//   void _showVerificationSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF0F172A),
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.verified_user_outlined, color: Color(0xFFFFB74D), size: 40),
//             const SizedBox(height: 15),
//             const Text("VERIFY EXCHANGE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
//             const Text("Enter the 6-digit code shown on the seller's screen.", 
//               textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            
//             const SizedBox(height: 25),
            
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 18),
//               decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
//               child: const TextField(
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.number,
//                 maxLength: 6,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8, color: Color(0xFFFFB74D)),
//                 decoration: InputDecoration(counterText: "", border: InputBorder.none, hintText: "000000"),
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFF8C00),
//                   padding: const EdgeInsets.symmetric(vertical: 18),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//                 ),
//                 child: const Text("CONFIRM PURCHASE", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildAppBar(context), // FIXED: Passing context
//         _buildToggleButton(),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(24),
//             children: [
//               _buildHistoryCard(
//                 title: "Atlas Ranger V2",
//                 price: "₹1,500",
//                 date: "24/01/2026",
//                 userLabel: isBoughtTab ? "FROM" : "TO",
//                 userName: isBoughtTab ? "USER_402" : "USER_881",
//                 icon: Icons.directions_bike,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // --- 2. UPDATED APP BAR WITH SCANNER ---
//   Widget _buildAppBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           RichText(
//             text: const TextSpan(
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
//               children: [
//                 TextSpan(text: "CEM"),
//                 TextSpan(text: ".", style: TextStyle(color: Color(0xFFFFB74D))),
//                 TextSpan(text: "HISTORY")
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               // Scanner button replaces theme moon
//               _buildActionBtn(
//                 Icons.qr_code_scanner, 
//                 onTap: () => _showVerificationSheet(context)
//               ),
//               _buildActionBtn(
//       Icons.notifications, 
//       onTap: () => _showActivityOverlay(context) // FIXED
//     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showActivityOverlay(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierColor: Colors.black.withOpacity(0.5), // Dim background for focus
//     builder: (context) => Stack(
//       children: [
//         Positioned(
//           top: 60, // Adjust based on your AppBar height
//           right: 24,
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               width: 300,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A212E), // Glassy Deep Navy
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(color: Colors.white.withOpacity(0.08)),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, offset: const Offset(0, 20))
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // --- HEADER ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("ACTIVITY", style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
//                       TextButton(onPressed: () {}, child: const Text("CLEAR ALL", style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.w900, fontSize: 10))),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   // --- NOTIFICATION ITEMS ---
//                   _buildActivityItem(
//                     icon: Icons.favorite,
//                     iconColor: const Color(0xFFFFB74D),
//                     content: TextSpan(
//                       text: "User Name ", 
//                       style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB74D)),
//                       children: [
//                         const TextSpan(text: "is interested in your ", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white)),
//                         const TextSpan(text: "Atlas Ranger V2", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB74D))),
//                         const TextSpan(text: ". Check your mail", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white)),
//                       ]
//                     ),
//                     time: "2 MINS AGO",
//                   ),

//                   const Divider(color: Colors.white10, height: 32),

//                   _buildActivityItem(
//                     icon: Icons.check_circle,
//                     iconColor: const Color(0xFF4CAF50),
//                     content: TextSpan(
//                       text: "Exchange verified for ", 
//                       style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
//                       children: [
//                         const TextSpan(text: "Data Structures ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB74D))),
//                         const TextSpan(text: "book. Listing moved to Sold.", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white)),
//                       ]
//                     ),
//                     time: "1 HOUR AGO",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildActivityItem({required IconData icon, required Color iconColor, required TextSpan content, required String time}) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
//         child: Icon(icon, color: iconColor, size: 14),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             RichText(text: TextSpan(style: const TextStyle(fontSize: 11, height: 1.4), children: [content])),
//             const SizedBox(height: 4),
//             Text(time, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     ],
//   );
// }

//   // FIXED: Added onTap and GestureDetector
//   Widget _buildActionBtn(IconData icon, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(left: 12),
//         width: 42, height: 42,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.08), 
//           borderRadius: BorderRadius.circular(12), 
//           border: Border.all(color: Colors.white10)
//         ),
//         child: Icon(icon, color: const Color(0xFFFFB74D), size: 20),
//       ),
//     );
//   }

//   // ... (Rest of your UI helpers: _buildToggleButton, _buildTabItem, _buildHistoryCard)
//   Widget _buildToggleButton() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//       height: 55,
//       decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         children: [
//           _buildTabItem("BOUGHT", isBoughtTab, () => setState(() => isBoughtTab = true)),
//           _buildTabItem("SOLD", !isBoughtTab, () => setState(() => isBoughtTab = false)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabItem(String label, bool isActive, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           margin: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: isActive ? const Color(0xFFFFB74D) : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Center(
//             child: Text(label, style: TextStyle(color: isActive ? Colors.black : const Color(0xFF94A3B8), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHistoryCard({required String title, required String price, required String date, required String userLabel, required String userName, required IconData icon}) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
//       child: Row(
//         children: [
//           Container(
//             width: 60, height: 60,
//             decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
//             child: Icon(icon, color: const Color(0xFFFFB74D), size: 28),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 const SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
//                     children: [TextSpan(text: "$userLabel: "), TextSpan(text: userName, style: const TextStyle(color: Color(0xFFFFB74D)))],
//                   ),
//                 ),
//                 Text("DATE: $date", style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//           Text(price, style: const TextStyle(color: Color(0xFFFFB74D), fontSize: 18, fontWeight: FontWeight.w900)),
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/listing_service.dart';
import '../domain/listing_model.dart';

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
            // Dynamic history based on current mock account
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
          Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)), child: Icon(item.isSeeking ? Icons.person_search : Icons.directions_bike, color: const Color(0xFFFFB74D), size: 28)),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 4),
                Text(isBoughtTab ? "EXCHANGED" : "SOLD", style: const TextStyle(fontSize: 10, color: Color(0xFFFFB74D), fontWeight: FontWeight.bold)),
                Text("DATE: JUST NOW", style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
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
          Row(children: [_buildActionBtn(Icons.qr_code_scanner, onTap: () => _showVerificationSheet(context)), _buildActionBtn(Icons.notifications)]),
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