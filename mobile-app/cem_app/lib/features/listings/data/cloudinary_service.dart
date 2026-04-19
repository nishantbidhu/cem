import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  // --- REPLACE THESE WITH YOUR CLOUDINARY DETAILS ---
  static const String cloudName = 'dgldc9hbe'; 
  static const String uploadPreset = 'cem_uploads'; 

  /// Uploads a file directly to Cloudinary using an unsigned preset.
  /// Returns the secure HTTPS image URL if successful, or null if it fails.
  Future<String?> uploadImage(File imageFile) async {
    try {
      final Uri uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);

      // Attach the unsigned upload preset
      request.fields['upload_preset'] = uploadPreset;

      // Attach the actual image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send the request to Cloudinary
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);
        
        String originalUrl = jsonMap['secure_url']; 
        
        // --- THE iOS FIX: Inject Cloudinary's auto-format and auto-quality tags ---
        // This instantly converts iPhone HEIC photos into fast-loading WebP/JPEGs!
        String optimizedUrl = originalUrl.replaceFirst('/upload/', '/upload/f_auto,q_auto/');
        
        return optimizedUrl; 
      } else {
        debugPrint('Cloudinary Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Failed to upload image to Cloudinary: $e');
      return null;
    }
  }
}