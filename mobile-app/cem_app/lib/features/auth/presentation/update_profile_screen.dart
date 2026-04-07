

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  String? _selectedHostel;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch existing data from Firestore
  // Fetch existing data from Firestore safely
  Future<void> _loadUserData() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
        
        if (userDoc.exists) {
          // Safely cast data to Map to prevent StateErrors on missing fields
          final data = userDoc.data() as Map<String, dynamic>?;
          setState(() {
            _selectedHostel = data?['hostel'] ?? AppConstants.hostels.first;
            _phoneController.text = data?['phone'] ?? '';
            _nameController.text = data?['name'] ?? '';
          });
        } else {
          // If the user document doesn't exist yet (old accounts)
          setState(() {
            _selectedHostel = AppConstants.hostels.first;
            _phoneController.text = '';
          });
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      // The 'finally' block ensures the spinner ALWAYS turns off
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Save new data to Firestore
  Future<void> _saveProfile() async {
    if (currentUser == null) return;
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
        'name': _nameController.text.trim(),
        'hostel': _selectedHostel,
        'phone': _phoneController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!"), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB74D)), onPressed: () => Navigator.pop(context)),
        title: const Text("Update Profile", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB74D)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLockedIdentityCard(),
                const SizedBox(height: 30),
                _buildSectionLabel("FULL NAME"),
                _buildGlassTextField(Icons.person, _nameController, "Your Name"),
                const SizedBox(height: 20),
                _buildSectionLabel("CURRENT HOSTEL"),
                _buildHostelDropdown(),
                const SizedBox(height: 20),
                _buildSectionLabel("WHATSAPP / PHONE NUMBER"),
                _buildGlassTextField(Icons.phone, _phoneController),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildLockedIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.lock, color: Color(0xFFFFB74D), size: 14),
            const SizedBox(width: 8),
            Text("VERIFIED IDENTITY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFFFB74D).withOpacity(0.8), letterSpacing: 1)),
          ]),
          const SizedBox(height: 12),
          const Text("Student Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(currentUser?.email ?? "No Email", style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 12),
          const Text("Email is derived from your institutional ID and cannot be modified.", style: TextStyle(fontSize: 10, color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)));
  }

  Widget _buildHostelDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedHostel,
          dropdownColor: const Color(0xFF1A212E),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
          items: AppConstants.hostels.map((h) => DropdownMenuItem(value: h, child: Row(children: [const Icon(Icons.apartment, color: Color(0xFFFFB74D), size: 18), const SizedBox(width: 12), Text(h, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))).toList(),
          onChanged: (val) => setState(() => _selectedHostel = val!),
        ),
      ),
    );
  }

  Widget _buildGlassTextField(IconData icon, TextEditingController controller, [String hint = "+91 00000 00000"]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white10)),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFFFFB74D), size: 18), 
          border: InputBorder.none, 
          hintText: hint, // <-- NOW USES THE DYNAMIC HINT
          hintStyle: const TextStyle(color: Colors.white24)
        ),
      ),
    );
  }
}