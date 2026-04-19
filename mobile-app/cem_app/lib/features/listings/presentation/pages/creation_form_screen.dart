import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/listing_service.dart';
import '../../domain/listing_model.dart';
// IMPORTANT: Update this import path to wherever you saved cloudinary_service.dart!
import '../../data/cloudinary_service.dart'; 

class CreationFormScreen extends StatefulWidget {
  final bool isSalePost; 
  final Listing? existingListing;
  const CreationFormScreen({super.key, required this.isSalePost, this.existingListing});

  @override
  State<CreationFormScreen> createState() => _CreationFormScreenState();
}

class _CreationFormScreenState extends State<CreationFormScreen> {
  final ListingService _listingService = ListingService();
  final CloudinaryService _cloudinaryService = CloudinaryService(); // --- NEW: CLOUDINARY INSTANCE ---
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  String _selectedCategory = 'Bicycles';
  String _selectedCondition = 'Used - Good';

  final List<String> _categories = ['Bicycles', 'Tech/Electronics', 'Books/Notes', 'Lab Gear', 'Others'];
  final List<String> _conditions = ['New', 'Like New', 'Used - Good', 'Used - Fair'];

  File? _selectedImage;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.existingListing != null) {
      _titleController.text = widget.existingListing!.title;
      _priceController.text = widget.existingListing!.priceText.replaceAll(RegExp(r'[^0-9.]'), '');
      
      String oldDesc = widget.existingListing!.description;
      if (oldDesc.contains('\nCondition:')) {
        oldDesc = oldDesc.split('\nCondition:')[0];
      }
      _detailsController.text = oldDesc;
      
      _selectedCategory = widget.existingListing!.category;
      _selectedCondition = widget.existingListing!.condition;
      _existingImageUrl = widget.existingListing!.imageUrl; 
    }
  }

  Future<void> _pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60, 
      maxWidth: 800,    
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _existingImageUrl = null; 
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: User not logged in")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String userHostel = "IITJ Campus"; 
      if (widget.existingListing == null) { 
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUid).get();
        if (userDoc.exists) {
          userHostel = (userDoc.data() as Map<String, dynamic>?)?['hostel'] ?? "IITJ Campus";
        }
      } else {
        userHostel = widget.existingListing!.location; 
      }

      String finalPriceText = widget.isSalePost ? "₹${_priceController.text}" : "Budget: ₹${_priceController.text}";
      String generatedId = widget.existingListing?.id ?? const Uuid().v4();

      // --- NEW: UPLOAD TO CLOUDINARY INSTEAD OF FIREBASE ---
      String? finalImageUrl = _existingImageUrl; // Default to existing if no new image
      
      if (_selectedImage != null) {
        finalImageUrl = await _cloudinaryService.uploadImage(_selectedImage!);
        
        // If upload fails, alert user and stop submission
        if (finalImageUrl == null) {
          throw Exception("Image upload to Cloudinary failed. Please try again.");
        }
      }

      final newListing = Listing(
        id: generatedId,
        title: _titleController.text.trim(),
        priceText: finalPriceText,
        category: _selectedCategory,
        location: userHostel, 
        condition: _selectedCondition,
        description: "${_detailsController.text.trim()}\nCondition: $_selectedCondition",
        isSeeking: !widget.isSalePost,
        sellerId: currentUid, 
        imageUrl: finalImageUrl, // <-- NOW CONTAINS THE CLOUDINARY URL
        transactionCode: widget.existingListing?.transactionCode,
        boughtBy: widget.existingListing?.boughtBy,
      );

      if (widget.existingListing != null) {
        await _listingService.updateListing(newListing);
      } else {
        await _listingService.addListing(newListing);
      }

      // --- UPDATED SUCCESS MESSAGE WITH TIP ---
      // --- UPDATED SUCCESS MESSAGE WITH TIP & MARGIN ---
      if (mounted) {
        final isNewPost = widget.existingListing == null;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNewPost 
                  ? "Successfully Published!\n\nTip: Find the product code in My Listings." 
                  : "Listing Successfully Updated!",
              style: const TextStyle(color: Colors.white, height: 1.4, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5), 
            behavior: SnackBarBehavior.floating, 
            
            // --- THE FIX: Push the snackbar up to clear the custom dock ---
            margin: const EdgeInsets.only(bottom: 110, left: 20, right: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Makes the edges nicely rounded too!
          )
        );
        Navigator.pop(context); // Go back to the feed
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFFFFB74D)),
        title: Text(widget.isSalePost ? "NEW SALE POST" : "NEW SEEK REQUEST",
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 18),

              _buildTextField("Title", "e.g. Atlas Cycle", _titleController, isRequired: true),
              _buildDropdownField("Category", _categories, _selectedCategory, (val) => setState(() => _selectedCategory = val!)),
              _buildTextField(widget.isSalePost ? "Price (₹)" : "Max Budget (₹)", "0.00", _priceController, isNumber: true, isRequired: true),
              _buildDropdownField("Condition", _conditions, _selectedCondition, (val) => setState(() => _selectedCondition = val!)),
              _buildTextField("Details", "Describe item...", _detailsController, isMultiline: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C00),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("CONFIRM & PUBLISH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickAndCompressImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : _existingImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(_existingImageUrl!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo, color: Color(0xFFFFB74D), size: 40),
                      SizedBox(height: 10),
                      Text("Tap to add a photo", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isNumber = false, bool isMultiline = false, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white10)),
            child: TextFormField(
              controller: controller,
              keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : (isMultiline ? TextInputType.multiline : TextInputType.text),
              maxLines: isMultiline ? 3 : 1,
              maxLength: label.toLowerCase() == "title" ? 40 : null,
              style: const TextStyle(color: Colors.white),
              validator: isRequired ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
              decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)), border: InputBorder.none),
            ),
          ),
      ]),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String currentValue, void Function(String?) onChanged) {
     return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white10)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                dropdownColor: const Color(0xFF1A212E),
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFFB74D)),
                items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
      ]),
    );
  }
}