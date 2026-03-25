// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../domain/listing_model.dart'; 

// class ListingService {
//   final CollectionReference _listings = 
//       FirebaseFirestore.instance.collection('listings');

//   // Stream for Marketplace (Sales only)
//   Stream<List<Listing>> getSaleListings() {
//     return _listings
//         .where('isSeeking', isEqualTo: false)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//           .toList();
//     });
//   }

//   // Stream for Seek Feed (Requests only)
//   Stream<List<Listing>> getSeekListings() {
//     return _listings
//         .where('isSeeking', isEqualTo: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//           .toList();
//     });
//   }

//   Future<void> addListing(Listing listing) {
//     return _listings.add(listing.toMap());
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      print("Error deleting listing: $e");
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
      return false; 
    } catch (e) {
      return false;
    }
  }
}