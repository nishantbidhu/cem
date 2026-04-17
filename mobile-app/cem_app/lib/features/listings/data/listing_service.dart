import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // ADDED for debugPrint
import 'dart:math';
import '../domain/listing_model.dart';

class ListingService {
  final CollectionReference _listings = 
      FirebaseFirestore.instance.collection('listings');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- CREATE ---
  Future<void> addListing(Listing listing) async {
    String vCode = (Random().nextInt(900000) + 100000).toString();
    return await _listings.doc(listing.id).set({
      ...listing.toMap(),
      'transactionCode': vCode,
      'status': 'available',
      'createdAt': FieldValue.serverTimestamp(),
      'sellerId': _auth.currentUser?.uid ?? 'anonymous', // Dynamic Seller ID
    });
  }

  // --- UPDATE ---
  Future<void> updateListing(Listing listing) async {
    return await _listings.doc(listing.id).update(listing.toMap());
  }

  // --- READ: MARKETPLACE ---
  Stream<List<Listing>> getSaleListings() {
    return _listings
        .where('isSeeking', isEqualTo: false)
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          // FIXED: Passing Data AND Doc ID
          return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList());
  }

  // --- READ: FUTURE (One-time fetch for pull-to-refresh) ---
  Future<List<Listing>> getSaleListingsFuture() async {
    final snapshot = await _listings
        .where('isSeeking', isEqualTo: false)
        .where('status', isEqualTo: 'available')
        .get(); // .get() instead of .snapshots()
        
    return snapshot.docs.map((doc) {
      return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Stream<List<Listing>> getSeekListings() {
    return _listings
        .where('isSeeking', isEqualTo: true)
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList());
  }

  // --- READ: USER SPECIFIC ---
  Stream<List<Listing>> getUserListings(String userId) {
    return _listings
        .where('sellerId', isEqualTo: userId)
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList());
  }

  // --- DELETE ---
  Future<void> deleteListing(String documentId) async {
    try {
      await _listings.doc(documentId).delete();
    } catch (e) {
      // FIXED: Using debugPrint for clean production builds
      debugPrint("Error deleting listing: $e"); 
    }
  }

  // --- READ: HISTORY ---
  Stream<List<Listing>> getSoldHistory(String userId) {
    return _listings
        .where('sellerId', isEqualTo: userId)
        .where('status', isEqualTo: 'sold')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList());
  }

  Stream<List<Listing>> getBoughtHistory(String userId) {
    return _listings
        .where('boughtBy', isEqualTo: userId)
        .where('status', isEqualTo: 'sold')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList());
  }

  // --- SYNC: GLOBAL HANDSHAKE ---
  Future<bool> completeTransactionByCode(String code, String buyerId) async {
    try {
      final QuerySnapshot result = await _listings
          .where('transactionCode', isEqualTo: code)
          .where('status', isEqualTo: 'available')
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        String docId = result.docs.first.id;
        await _listings.doc(docId).update({
          'status': 'sold',
          'boughtBy': buyerId, // Links item to buyer's history
          'completedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false; // Code not found or item not available
    } catch (e) {
      debugPrint("Handshake Error: $e"); // Added debugPrint here too!
      return false;
    }
  }

  // --- NEW: LAZY SELF-CLEANUP (7 DAYS) ---
  Future<List<String>> cleanupExpiredListings() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    List<String> deletedTitles = [];
    
    try {
      // Calculate the exact time 7 days ago
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      
      // Find the user's active listings that are older than 7 days
      final snapshot = await _listings
          .where('sellerId', isEqualTo: userId)
          .where('status', isEqualTo: 'available')
          .where('createdAt', isLessThan: Timestamp.fromDate(sevenDaysAgo))
          .get();

      // Delete them and save the titles to notify the user
      for (var doc in snapshot.docs) {
        deletedTitles.add(doc['title'] ?? 'Item');
        await doc.reference.delete();
      }
      
      return deletedTitles;
    } catch (e) {
      debugPrint("Cleanup error: $e");
      return [];
    }
  }
}